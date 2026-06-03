import 'package:flutter/material.dart';
import '../models/item_compra.dart';
import '../widgets/item_widget.dart';

class ListaComprasScreen extends StatefulWidget {
  const ListaComprasScreen({super.key});

  @override
  State<ListaComprasScreen> createState() => _ListaComprasScreenState();
}

class _ListaComprasScreenState extends State<ListaComprasScreen> {
  // 1. O NOSSO BANCO DE DADOS NA MEMÓRIA
  final List<ItemCompra> _meusItens = [
    ItemCompra(id: '1', nome: 'Picanha', quantidade: 2),
    ItemCompra(id: '2', nome: 'Pão de Alho', quantidade: 3),
    ItemCompra(id: '3', nome: 'Saco de Carvão', quantidade: 1),
  ];

  // Controladores para capturar o que o usuário digita no formulário
  final _nomeController = TextEditingController();
  final _qtdController = TextEditingController();

  // Função para abrir o formulário na parte inferior da tela (BottomSheet)
  void _abrirFormularioCadastro() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Item (Ex: Linguiça)'),
              ),
              TextField(
                controller: _qtdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarNovoItem,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text(
                  'Adicionar ao Churrasco',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Função executada quando o usuário clica em "Adicionar" no formulário
  void _adicionarNovoItem() {
    final nomeDigitado = _nomeController.text;
    final qtdDigitada = int.tryParse(_qtdController.text) ?? 1;

    if (nomeDigitado.isEmpty) return;

    final novoItem = ItemCompra(
      id: DateTime.now().toString(),
      nome: nomeDigitado,
      quantidade: qtdDigitada,
    );

    setState(() {
      _meusItens.add(novoItem);
    });

    _nomeController.clear();
    _qtdController.clear();
    Navigator.of(context).pop();
  }

  // PASSO 2 DO DESAFIO: A Lógica de Remoção
  void _removerItem(String id) {
    setState(() {
      // Remove da lista na memória para não reaparecer
      _meusItens.removeWhere((item) => item.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item removido do churrasco!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Desafio de Incremento: Fundo cinza para destacar os cards
      backgroundColor: Colors.grey[200],

      // PASSO 3 DO DESAFIO: O Resumo da Lista (Contador Dinâmico)
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista do Churrasco',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            // Cálculo em tempo real: Filtra quem está comprado e conta o total
            Text(
              '${_meusItens.where((item) => item.foiComprado).length} de ${_meusItens.length} itens comprados',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
      ),

      // 2. O RENDERIZADOR DA LISTA
      body: ListView.builder(
        itemCount: _meusItens.length,
        itemBuilder: (context, index) {
          final itemAtual = _meusItens[index];

          // PASSO 1 DO DESAFIO: O Gesto de Deletar (Dismissible)
          return Dismissible(
            key: ValueKey(itemAtual.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removerItem(itemAtual.id);
            },
            child: ItemWidget(
              item: itemAtual,
              aoMudarStatus: () {
                // Ao clicar no checkbox, o setState redesenha a tela e atualiza a AppBar
                setState(() {
                  itemAtual.foiComprado = !itemAtual.foiComprado;
                });
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormularioCadastro,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}