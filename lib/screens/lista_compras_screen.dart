import 'package:flutter/material.dart';
import '../models/item_compra.dart';
import '../widgets/item_widget.dart';

class ListaComprasScreen extends StatefulWidget {
  const ListaComprasScreen({super.key});

  @override
  State<ListaComprasScreen> createState() => _ListaComprasScreenState();
}

class _ListaComprasScreenState extends State<ListaComprasScreen> {
  // Banco de dados inicial em memória com as categorias
  final List<ItemCompra> _meusItens = [
    ItemCompra(id: '1', nome: 'Picanha', quantidade: 2, categoria: 'Carne'),
    ItemCompra(id: '2', nome: 'Pão de Alho', quantidade: 3, categoria: 'Outro'),
    ItemCompra(id: '3', nome: 'Saco de Carvão', quantidade: 1, categoria: 'Outro'),
  ];

  // Estado para controlar qual filtro de botões está ativo
  String _filtroAtivo = 'Todos';

  final _nomeController = TextEditingController();
  final _qtdController = TextEditingController();
  
  // Variáveis para controlar a funcionalidade de Categorias e Validação
  String _categoriaSelecionada = 'Carne';
  String? _erroNome;
  String? _erroQtd;

  // Função que devolve a lista filtrada E ordenada (comprados vão para o fim)
  List<ItemCompra> get _itensExibidos {
    List<ItemCompra> listaFiltrada = [];

    // 1. Aplica o filtro dos botões (Chips)
    if (_filtroAtivo == 'Todos') {
      listaFiltrada = List.from(_meusItens);
    } else if (_filtroAtivo == 'Pendentes') {
      listaFiltrada = _meusItens.where((item) => !item.foiComprado).toList();
    } else if (_filtroAtivo == 'Comprados') {
      listaFiltrada = _meusItens.where((item) => item.foiComprado).toList();
    }

    // 2. Ordenação automática (itens marcados descem)
    listaFiltrada.sort((a, b) {
      if (a.foiComprado && !b.foiComprado) return 1;
      if (!a.foiComprado && b.foiComprado) return -1;
      return 0;
    });

    return listaFiltrada;
  }

  // Alerta de confirmação antes de deletar a lista toda
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

  // Abre o formulário inteligente (Novo ou Editar)
  void _abrirFormularioCadastro([ItemCompra? itemParaEditar]) {
    if (itemParaEditar != null) {
      _nomeController.text = itemParaEditar.nome;
      _qtdController.text = itemParaEditar.quantidade.toString();
      _categoriaSelecionada = itemParaEditar.categoria;
    } else {
      _nomeController.clear();
      _qtdController.clear();
      _categoriaSelecionada = 'Carne';
    }

    setState(() {
      _erroNome = null;
      _erroQtd = null;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    itemParaEditar == null ? 'Novo Item do Churrasco' : 'Editar Item',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome do Item',
                      errorText: _erroNome,
                    ),
                  ),
                  TextField(
                    controller: _qtdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantidade',
                      errorText: _erroQtd,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Categoria:', style: TextStyle(fontSize: 16)),
                      DropdownButton<String>(
                        value: _categoriaSelecionada,
                        items: ['Carne', 'Bebida', 'Outro'].map((String valor) {
                          return DropdownMenuItem<String>(
                            value: valor,
                            child: Text(valor),
                          );
                        }).toList(),
                        onChanged: (novoValor) {
                          if (novoValor != null) {
                            setModalState(() => _categoriaSelecionada = novoValor);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _salvarItem(itemParaEditar),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    child: Text(
                      itemParaEditar == null ? 'Adicionar ao Churrasco' : 'Salvar Alterações',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _salvarItem(ItemCompra? itemParaEditar) {
    final nome = _nomeController.text.trim();
    final qtd = int.tryParse(_qtdController.text) ?? 0;

    bool temErro = false;
    setState(() {
      if (nome.isEmpty) {
        _erroNome = 'O nome não pode ficar vazio!';
        temErro = true;
      } else {
        _erroNome = null;
      }

      if (qtd <= 0) {
        _erroQtd = 'A quantidade deve ser maior que 0!';
        temErro = true;
      } else {
        _erroQtd = null;
      }
    });

    if (temErro) return;

    if (itemParaEditar == null) {
      final novoItem = ItemCompra(
        id: DateTime.now().toString(),
        nome: nome,
        quantidade: qtd,
        categoria: _categoriaSelecionada,
      );
      setState(() => _meusItens.add(novoItem));
    } else {
      setState(() {
        final index = _meusItens.indexWhere((item) => item.id == itemParaEditar.id);
        if (index != -1) {
          _meusItens[index] = ItemCompra(
            id: itemParaEditar.id,
            nome: nome,
            quantidade: qtd,
            categoria: _categoriaSelecionada,
            foiComprado: itemParaEditar.foiComprado,
          );
        }
      });
    }

    Navigator.of(context).pop();
  }

  void _removerItem(String id) {
    setState(() => _meusItens.removeWhere((item) => item.id == id));
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
          // BOTÕES DE FILTRO VOLTARAM! (Todos / Pendentes / Comprados)
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
          // Lista de itens filtrada ou mensagem vazia
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
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: const Icon(Icons.edit, color: Colors.white, size: 30),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: const Icon(Icons.delete, color: Colors.white, size: 30),
                        ),
                        direction: DismissDirection.horizontal,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            _abrirFormularioCadastro(itemAtual);
                            return false; 
                          }
                          return true;
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            _removerItem(itemAtual.id);
                          }
                        },
                        child: ItemWidget(
                          item: itemAtual,
                          aoMudarStatus: () {
                            setState(() => itemAtual.foiComprado = !itemAtual.foiComprado);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormularioCadastro(),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}