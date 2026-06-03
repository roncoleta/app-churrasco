import 'package:flutter/material.dart';
import '../models/item_compra.dart';

class ItemWidget extends StatelessWidget {
  final ItemCompra item;
  final VoidCallback aoMudarStatus;

  const ItemWidget({
    super.key,
    required this.item,
    required this.aoMudarStatus,
  });

  // Função auxiliar para definir a cor baseada na categoria
  Color _obterCorCategoria(String categoria) {
    switch (categoria) {
      case 'Carne':
        return Colors.redAccent;
      case 'Bebida':
        return Colors.blueAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final corCategoria = _obterCorCategoria(item.categoria);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: corCategoria, width: 5),
          ),
        ),
        child: ListTile(
          title: Text(
            item.nome,
            style: TextStyle(
              fontSize: 18,
              decoration: item.foiComprado ? TextDecoration.lineThrough : null,
              color: item.foiComprado ? Colors.grey : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Row(
            children: [
              Text('Qtd: ${item.quantidade}'),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: corCategoria.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  item.categoria,
                  style: TextStyle(color: corCategoria, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          trailing: Checkbox(
            activeColor: Colors.redAccent,
            value: item.foiComprado,
            onChanged: (_) => aoMudarStatus(),
          ),
        ),
      ),
    );
  }
}