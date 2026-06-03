class ItemCompra {
  final String id;
  final String nome;
  final int quantidade;
  bool foiComprado;
  final String categoria; // Nova propriedade: 'Carne', 'Bebida' ou 'Outro'

  ItemCompra({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.foiComprado = false,
    this.categoria = 'Outro', // Padrão se não escolher nada
  });
}