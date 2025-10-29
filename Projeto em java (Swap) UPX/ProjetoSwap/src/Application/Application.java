package Application;

import java.util.Scanner;
import java.util.List; // Necessário importar
import java.util.ArrayList; // Necessário importar
import Entities.Contrato;
import Entities.Entitie;

public class Application {
    public static void main(String[] args) {
        
        // --- CORREÇÃO: Criando e populando a lista aqui ---
        List<Contrato> listaDeContratos = new ArrayList<>();
        listaDeContratos.add(new Contrato("Pedro", 10.0));
        listaDeContratos.add(new Contrato("Ana", 20.0));
        listaDeContratos.add(new Contrato("Lucas", 15.0));
        // --- Fim da Correção ---

        Scanner sc = new Scanner(System.in);

        System.out.println("Olá! Seja bem-vindo à plataforma Swap! Vamos fazer seu cadastro? (S/N)");
        char r = sc.next().charAt(0);
        sc.nextLine(); // Limpa buffer

        if (r == 'S' || r == 's') {
            System.out.print("Insira seu nome: ");
            String nome = sc.nextLine();

            System.out.print("Insira seu email: ");
            String email = sc.nextLine();

            System.out.print("Insira seu saldo: ");
            double saldo = sc.nextDouble();
            sc.nextLine(); // Limpa buffer

            // Assumindo que a classe Entitie existe e funciona
            Entitie p1 = new Entitie(nome, email, saldo); 

            System.out.println("Deseja ver os contratos disponíveis? (S/N)");
            char r1 = sc.next().charAt(0);
            sc.nextLine(); // Limpa buffer

            if (r1 == 'S' || r1 == 's') {
                System.out.println("--- Contratos Disponíveis ---");
                
                // Loop corrigido para iterar sobre a lista local
                for (int i = 0; i < listaDeContratos.size(); i++) {
                    // O método toString() da classe Contrato será chamado aqui
                    System.out.println("#" + i + " - " + listaDeContratos.get(i));
                }
                System.out.println("-----------------------------");


                System.out.print("Escolha qual contrato deseja pelo número: ");
                int escolha = sc.nextInt();
                sc.nextLine(); // Limpa buffer

                // Lógica de escolha corrigida para usar a lista local
                if (escolha >= 0 && escolha < listaDeContratos.size()) {
                    Contrato contratoEscolhido = listaDeContratos.get(escolha);
                    System.out.println("Você escolheu o contrato: " + contratoEscolhido);

                    // Associa o contrato ao usuário (assumindo que p1.adicionarContrato existe)
                    p1.adicionarContrato(contratoEscolhido);

                    System.out.print("Deseja pagar esse contrato com serviço? (S/N): ");
                    char mk = sc.next().charAt(0);
                    sc.nextLine(); // Limpa buffer

                    // Método de pagamento (assumindo que p1.metodoPagamento existe)
                    p1.metodoPagamento(mk);

                    System.out.println("Obrigado! Volte sempre!");
                } else {
                    System.out.println("Opção inválida!");
                }
            } else {
                System.out.println("Ok, volte sempre!");
            }
        } else {
            System.out.println("Programa encerrado!");
        }

        sc.close();
    }
}