import 'package:flutter/material.dart';
import '../models/roupa.dart';
import '../models/tag.dart';
import '../services/storage_service.dart';
import '../widgets/card_roupa.dart';
import 'cadastro_screen.dart';
import 'gerenciamento_tags_screen.dart';

class TelaInventario extends StatefulWidget {
  final List<Roupa> roupas;
  TelaInventario({required this.roupas});

  @override
  State<TelaInventario> createState() => _TelaInventarioState();
}

class _TelaInventarioState extends State<TelaInventario> {
  List<Tag> _todasAsTags = [];
  List<String> _filtrosSelecionadosIds = [];
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _carregarTags();
  }

  // Precisamos carregar as tags para que o pop-up tenha o que mostrar
  void _carregarTags() async {
    final tags = await _storage.carregarTags();
    setState(() {
      _todasAsTags = tags;
    });
  }

  // Lógica que decide quais roupas aparecem na tela
  List<Roupa> get _roupasFiltradas {
    if (_filtrosSelecionadosIds.isEmpty) {
      return widget.roupas;
    }
    // Retorna apenas roupas que possuem PELO MENOS UMA das tags selecionadas
    return widget.roupas.where((roupa) {
      return _filtrosSelecionadosIds.any((id) => roupa.tagIds.contains(id));
    }).toList();
  }

  void _mostrarDialogoFiltros(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Filtros:"),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GerenciamentoTagsScreen()),
                  );
                  _carregarTags(); // Recarrega caso o usuário tenha criado tags novas
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              Map<String, List<Tag>> tagsPorGrupo = {};
              for (var tag in _todasAsTags) {
                tagsPorGrupo.putIfAbsent(tag.grupo, () => []).add(tag);
              }

              return SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_todasAsTags.isEmpty)
                        const Text("Nenhuma tag encontrada. Toque na engrenagem."),
                      ...tagsPorGrupo.entries.map((grupo) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(grupo.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Wrap(
                              spacing: 8,
                              children: grupo.value.map((tag) {
                                final isSelected = _filtrosSelecionadosIds.contains(tag.id);
                                return FilterChip(
                                  label: Text(tag.nome),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    setState(() {
                                      val ? _filtrosSelecionadosIds.add(tag.id)
                                          : _filtrosSelecionadosIds.remove(tag.id);
                                    });
                                    setDialogState(() {});
                                  },
                                );
                              }).toList(),
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() => _filtrosSelecionadosIds.clear());
                              Navigator.pop(context);
                            },
                            child: const Text("Limpar", style: TextStyle(color: Colors.red)),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Aplicar"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos a lista filtrada para o GridView
    final listaExibida = _roupasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Inventário"),
        backgroundColor: Colors.orange,
        actions: [
          // Indicador visual de que há filtros ativos
          if (_filtrosSelecionadosIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Text("${_filtrosSelecionadosIds.length}",
                    style: const TextStyle(fontSize: 12, color: Colors.orange)),
              ),
            )
        ],
      ),
      body: listaExibida.isEmpty
          ? const Center(child: Text("Nenhum item corresponde aos filtros!"))
          : GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: listaExibida.length,
        itemBuilder: (context, index) {
          final roupa = listaExibida[index];
          return CardRoupa(
            roupa: roupa,
            onTap: () async {
              final Roupa? editada = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaCadastro(roupaParaEditar: roupa),
                ),
              );

              if (editada != null) {
                setState(() {
                  // Encontra o index real na lista original para atualizar
                  int originalIndex = widget.roupas.indexWhere((r) => r.id == roupa.id);
                  widget.roupas[originalIndex] = editada;
                });
                await StorageService.salvarRoupas(widget.roupas);
              }
            },
            onLongPress: () {
              // Diálogo de exclusão mantido como o seu original
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Excluir Peça"),
                  content: Text("Deseja remover ${roupa.nome}?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          widget.roupas.removeWhere((r) => r.id == roupa.id);
                        });
                        await StorageService.salvarRoupas(widget.roupas);
                        Navigator.pop(context);
                      },
                      child: const Text("Excluir", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.list, color: Colors.black),
        onPressed: () => _mostrarDialogoFiltros(context),
      ),
    );
  }
}