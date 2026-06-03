class ItemCompra {
  // Atributos protegidos
  final String id;
  final String nome;
  final int quantidade;
  bool foiComprado; // Não é final, pois o usuário vai marcar/desmarcar na tela

  // Construtor Nomeado exigindo os dados fundamentais
  ItemCompra({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.foiComprado = false, // O item sempre nasce como "não comprado"
  });
}