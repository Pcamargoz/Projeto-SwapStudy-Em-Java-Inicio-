-- swap_app_simple.sql
-- Schema mínimo para demonstrar cadastro de cliente, serviços, carteira (moeda do app) e swaps.
-- Compatível com SQLite. Recomendo ativar chaves estrangeiras: PRAGMA foreign_keys = ON;

PRAGMA foreign_keys = ON;

-- Tabelas principais -------------------------------------------------------

-- Usuários / Clientes
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Carteira do usuário (moeda do aplicativo)
CREATE TABLE IF NOT EXISTS wallets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  balance REAL NOT NULL DEFAULT 0, -- pode representar a "moeda" do app
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Serviços/ofertas que um usuário publica (pode trocar por serviço ou por moeda)
CREATE TABLE IF NOT EXISTS services (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  owner_id INTEGER NOT NULL,   -- user que criou a oferta
  title TEXT NOT NULL,
  description TEXT,
  price_in_coins REAL DEFAULT 0,  -- valor em moedas do app se quiser vender por moeda
  is_tradable BOOLEAN NOT NULL DEFAULT 1, -- se aceita troca por outro serviço
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Swap (pedido de troca) - registra proposta entre dois usuários/serviços
CREATE TABLE IF NOT EXISTS swaps (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  requester_id INTEGER NOT NULL,   -- quem iniciou a proposta
  responder_id INTEGER NOT NULL,   -- dono do serviço alvo
  service_id INTEGER NOT NULL,     -- serviço que o responder oferece
  offered_service_id INTEGER,      -- serviço que o requester oferece (opcional)
  offered_coins REAL DEFAULT 0,    -- ou coins oferecidos (opcional)
  status TEXT NOT NULL DEFAULT 'pending', -- pending / accepted / rejected / cancelled / completed
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (requester_id) REFERENCES users(id),
  FOREIGN KEY (responder_id) REFERENCES users(id),
  FOREIGN KEY (service_id) REFERENCES services(id),
  FOREIGN KEY (offered_service_id) REFERENCES services(id)
);

-- Histórico simples de transações em moedas (quando uma swap envolve coins)
CREATE TABLE IF NOT EXISTS transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  wallet_id INTEGER NOT NULL,
  amount REAL NOT NULL, -- negativo para débito, positivo para crédito
  type TEXT NOT NULL, -- e.g. 'swap_payment', 'refund', 'manual_adjust'
  reference TEXT, -- id da swap ou nota
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (wallet_id) REFERENCES wallets(id) ON DELETE CASCADE
);

-- Índices para performance mínima
CREATE INDEX IF NOT EXISTS idx_services_owner ON services(owner_id);
CREATE INDEX IF NOT EXISTS idx_swaps_requester ON swaps(requester_id);
CREATE INDEX IF NOT EXISTS idx_swaps_responder ON swaps(responder_id);


-- Dados de teste -----------------------------------------------------------

-- reset (só para ambientes de teste, comente se não quiser apagar dados)
-- DROP TABLE IF EXISTS transactions;
-- DROP TABLE IF EXISTS swaps;
-- DROP TABLE IF EXISTS services;
-- DROP TABLE IF EXISTS wallets;
-- DROP TABLE IF EXISTS users;

-- Inserindo usuários de exemplo
INSERT INTO users (name, email) VALUES ('Alice Silva', 'alice@example.com');
INSERT INTO users (name, email) VALUES ('Bruno Souza', 'bruno@example.com');
INSERT INTO users (name, email) VALUES ('Carla Mendes', 'carla@example.com');

-- Criando wallets para cada usuário (simplesmente pega os ids existentes)
INSERT INTO wallets (user_id, balance) SELECT id, 100.0 FROM users; -- cada usuário começa com 100 coins

-- Inserindo alguns serviços/ofertas
INSERT INTO services (owner_id, title, description, price_in_coins, is_tradable)
VALUES
((SELECT id FROM users WHERE email='alice@example.com'), 'Aula de JavaScript (1h)', 'Aula particular de JS básico', 30, 1),
((SELECT id FROM users WHERE email='bruno@example.com'), 'Design de logo', 'Criação de logo simples', 50, 1),
((SELECT id FROM users WHERE email='carla@example.com'), 'Revisão de TCC', 'Revisão textual e formatação', 40, 1);

-- Cenário de teste: Alice quer contratar o serviço "Design de logo" do Bruno.
-- Ela pode oferecer coins ou oferecer um serviço próprio em troca.
-- Exemplo 1: Alice oferece 50 coins para o serviço do Bruno
INSERT INTO swaps (requester_id, responder_id, service_id, offered_coins, status)
VALUES (
  (SELECT id FROM users WHERE email='alice@example.com'),
  (SELECT id FROM users WHERE email='bruno@example.com'),
  (SELECT id FROM services WHERE title='Design de logo'),
  50,
  'pending'
);

-- Exemplo 2: Carla propõe trocar seu 'Revisão de TCC' pelo 'Aula de JavaScript' da Alice
INSERT INTO swaps (requester_id, responder_id, service_id, offered_service_id, status)
VALUES (
  (SELECT id FROM users WHERE email='carla@example.com'),
  (SELECT id FROM users WHERE email='alice@example.com'),
  (SELECT id FROM services WHERE title='Aula de JavaScript (1h)'),
  (SELECT id FROM services WHERE title='Revisão de TCC'),
  'pending'
);


-- Funções/queries úteis para explicar o fluxo --------------------------------

-- 1) Listar swaps pendentes para um usuário (como responderia no resumo)
-- Substitua 'bruno@example.com' pelo email do usuário que vai ver as propostas
SELECT s.id, u_req.name AS requester, u_resp.name AS responder,
       ser.title AS target_service, os.title AS offered_service, s.offered_coins, s.status, s.created_at
FROM swaps s
JOIN users u_req ON u_req.id = s.requester_id
JOIN users u_resp ON u_resp.id = s.responder_id
LEFT JOIN services ser ON ser.id = s.service_id
LEFT JOIN services os ON os.id = s.offered_service_id
WHERE s.responder_id = (SELECT id FROM users WHERE email = 'bruno@example.com') AND s.status = 'pending';

-- 2) Aceitar um swap (exemplo simples que faz transferência de coins caso exista offered_coins)
-- OBS: execute tudo dentro de uma TRANSACTION para garantir atomicidade em produção.

-- Exemplo de como aceitar uma swap que usa coins:
-- (a) Encontrar a swap (substituir SWAP_ID pelo id real)
-- (b) Debitar coins do requester, creditar no wallet do responder, criar transactions e marcar swap como 'accepted' ou 'completed'

-- Exemplo prático (para swap com id = 1). Ajuste conforme o id retornado no seu DB:
BEGIN TRANSACTION;

-- 1) marcar swap como accepted (ou 'completed' se já finalizar todo o processo)
UPDATE swaps
SET status = 'accepted', updated_at = CURRENT_TIMESTAMP
WHERE id = 1 AND status = 'pending';

-- 2) movimentar coins (se houver offered_coins > 0)
-- Debita do wallet do requester
UPDATE wallets
SET balance = balance - (SELECT offered_coins FROM swaps WHERE id = 1)
WHERE user_id = (SELECT requester_id FROM swaps WHERE id = 1);

-- Credita no wallet do responder
UPDATE wallets
SET balance = balance + (SELECT offered_coins FROM swaps WHERE id = 1)
WHERE user_id = (SELECT responder_id FROM swaps WHERE id = 1);

-- Registrar transações (simples)
INSERT INTO transactions (wallet_id, amount, type, reference)
VALUES
((SELECT id FROM wallets WHERE user_id = (SELECT requester_id FROM swaps WHERE id = 1)), - (SELECT offered_coins FROM swaps WHERE id = 1), 'swap_payment', 'swap:1'),
((SELECT id FROM wallets WHERE user_id = (SELECT responder_id FROM swaps WHERE id = 1)),   (SELECT offered_coins FROM swaps WHERE id = 1), 'swap_receive', 'swap:1');

COMMIT;

-- Nota: o bloco acima é só um exemplo. Antes de rodar, verifique o ID da swap e se offered_coins > 0.
-- Para swaps que são apenas troca de serviços (offered_service_id set), o fluxo pode apenas atualizar status e notificar os envolvidos.

-- 3) Consultas rápidas para ver wallets e serviços
SELECT u.name, w.balance FROM wallets w JOIN users u ON u.id = w.user_id;
SELECT * FROM services;

-- 4) Cancelar ou rejeitar swap
UPDATE swaps SET status = 'rejected', updated_at = CURRENT_TIMESTAMP WHERE id = 2 AND status = 'pending';

-- Fim do arquivo
