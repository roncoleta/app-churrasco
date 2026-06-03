import 'package:flutter/material.dart';
import '../models/item_compra.dart';
import '../widgets/item_widget.dart';

class ListaComprasScreen extends StatefulWidget {
  const ListaComprasScreen({super.key});

  @override
  State<ListaComprasScreen> createState() => _ListaComprasScreenState();
}

class _ListaComprasScreenState extends State<ListaComprasScreen> {
  // Nosso Banco de Dados na Memória (CORRIGIDO: 'quantidade' em português)
  final List<ItemCompra> _meusItens = [
    ItemCompra(id: '1', nome: 'Picanha', quantidade: 2),
    ItemCompra(id: '2', nome: 'Pão de Alho', quantidade: 3),
    ItemCompra(id: '3', nome: 'Saco de Carvão', quantidade: 1),
  ];

  // Estado para controlar qual filtro está ativo
  // Opções: 'Todos', 'Pendentes', 'Comprados'
  String _filtroAtivo = 'Todos';

  final _nomeController = TextEditingController();
  final _qtdController = TextEditingController();

  // Função que devolve a lista filtrada e ORDENADA
  List<ItemCompra> get _itensExibidos {
    List<ItemCompra> listaFiltrada = [];

    // 1. Aplica o filtro selecionado pelo usuário
    if (_filtroAtivo == 'Todos') {
      listaFiltrada = List.from(_meusItens);
    } else if (_filtroAtivo == 'Pendentes') {
      listaFiltrada = _meusItens.where((item) => !item.foiComprado).toList();
    } else if (_filtroAtivo == 'Comprados') {
      listaFiltrada = _meusItens.where((item) => item.foiComprado).toList();
    }

    // 2. Joga os itens comprados para o final da lista automaticamente
    listaFiltrada.sort((a, b) {
      if (a.foiComprado && !b.foiComprado) return 1;  // 'a' vai para o fim
      if (!a.foiComprado && b.foiComprado) return -1; // 'a' fica no topo
      return 0; // Mantém a ordem se forem iguais
    });

    return listaFiltrada;
  }

  // Alerta de confirmação antes de deletar tudo
  void _confirmarLimparLista() {
    if (_meusItens.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar Lista?'),
        content: const Text('Tem certeza que deseja apagar todos os itens do churrasco?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _meusItens.clear();
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('A lista foi zerada!')),
              );
            },
            child: const Text('Apagar Tudo', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _abrirFormularioCadastro() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Melhora a visualização com o teclado aberto
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.0, // Ajusta com o teclado
          ),
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
                child: const Text('Adicionar ao Churrasco', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  void _adicionarNovoItem() {
    final nomeDigitado = _nomeController.text;
    final qtdDigitada = int.tryParse(_qtdController.text) ?? 1;

    if (nomeDigitado.isEmpty) return;

    // CORRIGIDO: mudado de 'quantity' para 'quantidade' para bater com o modelo
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

  void _removerItem(String id) {
    setState(() {
      _meusItens.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item removido!'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lista do Churrasco', style: TextStyle(color: Colors.white, fontSize: 20)),
            Text(
              '${_meusItens.where((item) => item.foiComprado).length} de ${_meusItens.length} itens comprados',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            tooltip: 'Limpar Lista',
            onPressed: _confirmarLimparLista,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de botões (Chips) para alternar os filtros
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Todos', 'Pendentes', 'Comprados'].map((filtro) {
                final inputSelecionado = _filtroAtivo == filtro;
                return ChoiceChip(
                  label: Text(filtro),
                  selected: inputSelecionado,
                  selectedColor: Colors.redAccent,
                  labelStyle: TextStyle(
                    color: inputSelecionado ? Colors.white : Colors.black87,
                    fontWeight: inputSelecionado ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _filtroAtivo = filtro;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),
          // Lista de Itens Renderizada de forma dinâmica
          Expanded(
            child: _itensExibidos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum item por aqui! 🥩',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _itensExibidos.length,
                    itemBuilder: (context, index) {
                      final itemAtual = _itensExibidos[index];

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
                            setState(() {
                              itemAtual.foiComprado = !itemAtual.foiComprado;
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormularioCadastro,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}