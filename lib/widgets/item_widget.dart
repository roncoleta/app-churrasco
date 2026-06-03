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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ListTile(
        title: Text(
          item.nome,
          style: TextStyle(
            fontSize: 18,
            decoration: item.foiComprado ? TextDecoration.lineThrough : null,
            color: item.foiComprado ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Text('Quantidade: ${item.quantidade}'),
        trailing: Checkbox(
          activeColor: Colors.redAccent,
          value: item.foiComprado,
          onChanged: (_) => aoMudarStatus(),
        ),
      ),
    );
  }
}