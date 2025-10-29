package Entities;

// Removido "import java.util.ArrayList" e "List" pois não são mais usados aqui
public class Contrato {

    private String contratante;
    private double valorContrato;
    
    // Removido: List<Contrato> contratos = new ArrayList<>();
    // Removido: Construtor padrão public Contrato(){}

    public Contrato(String contratante, double valorContrato) {
        this.contratante = contratante;
        this.valorContrato = valorContrato;
    }
    public Contrato(){
        
    }

    public String getContratante() {
        return contratante;
    }

    public void setContratante(String contratante) {
        this.contratante = contratante;
    }

    public double getValorContrato() {
        return valorContrato;
    }

    public void setValorContrato(double valorContrato) {
        this.valorContrato = valorContrato;
    }

    // Removido: public List<Contrato> getContratos()
    // Removido: public void criarContratos()

    // --- ADICIONADO: Método toString() ---
    // Isso permite que o contrato seja impresso de forma legível
    // Ex: "Contratante: Pedro, Valor: R$ 10.00"
    @Override
    public String toString() {
        return String.format("Contratante: %s, Valor: R$%.2f", contratante, valorContrato);
    }
}