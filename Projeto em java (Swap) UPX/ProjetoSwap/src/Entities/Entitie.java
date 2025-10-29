package Entities;

// Importe Contrato se não estiver no mesmo pacote (assumindo que está)
// import Entities.Contrato; 

public class Entitie {

    private String nome;
    private String email;
    private double saldo;
    private Contrato c; // O contrato escolhido pelo usuário será guardado aqui

    // --- Esta linha foi removida ---
    // private Contrato T = new Contrato(); // Não precisamos mais disso

    // Construtor padrão
    public Entitie() {
    }

    // Construtor com parâmetros
    public Entitie(String nome, String email, double saldo) {
        this.nome = nome;
        this.email = email;
        this.saldo = saldo;
    }

    // Método para guardar o contrato escolhido
    public void adicionarContrato(Contrato contratoEscolhido) {
        this.c = contratoEscolhido;
    }
    
    // Getters e Setters (vou omitir por brevidade, os seus estão corretos)
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public double getSaldo() { return saldo; }
    public void setSaldo(double saldo) { this.saldo = saldo; }
    public Contrato getC() { return c; }
    public void setC(Contrato c) { this.c = c; }


    // --- MÉTODO DE PAGAMENTO CORRIGIDO ---
    // Removi o parâmetro "double saldo" que não estava sendo usado
    public void metodoPagamento(char resposta) { 
        if (resposta == 'S' || resposta == 's') {
            System.out.println("Foi Pago com Serviço");
        } else if (resposta == 'N' || resposta == 'n') {
            System.out.println("Verificando Saldo...");
            System.out.println("Você possui: " + getSaldo() + " moedas");

            // Verificação de segurança (caso o contrato 'c' não tenha sido adicionado)
            if (c == null) {
                System.out.println("Erro: Nenhum contrato foi selecionado.");
                return;
            }

            // CORREÇÃO 1: Usando c.getValorContrato() ao invés de T.getValorContrato()
            if (getSaldo() < c.getValorContrato()) {
                System.out.println("Saldo Insuficiente!!!");
            } else {
                // CORREÇÃO 1: Usando c.getValorContrato()
                double newSaldo = getSaldo() - c.getValorContrato();
                
                // CORREÇÃO 2: Atualizando o saldo real do objeto
                setSaldo(newSaldo); 

                System.out.println("Pagamento efetuado com sucesso!!!");
                
                // Agora getSaldo() retorna o valor atualizado
                System.out.println("Seu novo saldo é de " + getSaldo()); 
            }
        }
    }
}