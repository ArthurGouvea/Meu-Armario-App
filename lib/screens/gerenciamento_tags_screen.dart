import 'package:flutter/material.dart';
import '../models/tag.dart';
import '../services/storage_service.dart';

class GerenciamentoTagsScreen extends StatefulWidget {
  @override
  _GerenciamentoTagsScreenState createState() => _GerenciamentoTagsScreenState();
}

class _GerenciamentoTagsScreenState extends State<GerenciamentoTagsScreen> {
  final StorageService _storage = StorageService();
  List<Tag> _todasAsTags = [];

  @override
  void initState() {
    super.initState();
    _carregarTags();
  }

  void _carregarTags() async {
    final tags = await _storage.carregarTags();
    setState(() => _todasAsTags = tags);
  }

  void _salvarEAtualizar() async {
    await _storage.salvarTags(_todasAsTags);
    _carregarTags();
  }

  // Pop-up de Edição/Criação (Sua Imagem 3)
  void _mostrarDialogoTag({Tag? tagExistente, String? grupoSugerido}) {
    TextEditingController nomeController = TextEditingController(text: tagExistente?.nome ?? "");

    // Pega os grupos únicos para o Dropdown
    List<String> gruposExistentes = _todasAsTags.map((t) => t.grupo).toSet().toList();
    if (!gruposExistentes.contains("Sem Grupo")) gruposExistentes.add("Sem Grupo");

    String grupoSelecionado = tagExistente?.grupo ?? grupoSugerido ?? "Sem Grupo";
    bool criandoNovoGrupo = false;
    TextEditingController novoGrupoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Necessário para atualizar o estado dentro do Dialog
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(tagExistente == null ? "Nova Tag" : "Editar Tag"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(labelText: "Nome da Tag"),
                  ),
                  const SizedBox(height: 15),
                  if (!criandoNovoGrupo)
                    DropdownButtonFormField<String>(
                      value: grupoSelecionado,
                      decoration: InputDecoration(labelText: "Grupo"),
                      items: gruposExistentes.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (val) => setDialogState(() => grupoSelecionado = val!),
                    )
                  else
                    TextField(
                      controller: novoGrupoController,
                      decoration: InputDecoration(labelText: "Nome do Novo Grupo"),
                    ),
                  TextButton(
                    onPressed: () => setDialogState(() => criandoNovoGrupo = !criandoNovoGrupo),
                    child: Text(criandoNovoGrupo ? "Escolher grupo existente" : "Criar novo grupo +"),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
                ElevatedButton(
                  onPressed: () {
                    String grupoFinal = criandoNovoGrupo ? novoGrupoController.text : grupoSelecionado;
                    if (nomeController.text.isEmpty) return;

                    if (tagExistente == null) {
                      _todasAsTags.add(Tag(nome: nomeController.text, grupo: grupoFinal));
                    } else {
                      tagExistente.nome = nomeController.text;
                      tagExistente.grupo = grupoFinal;
                    }
                    _salvarEAtualizar();
                    Navigator.pop(context);
                  },
                  child: Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Agrupamento das tags para o visual da Imagem 2
    Map<String, List<Tag>> tagsAgrupadas = {};
    for (var tag in _todasAsTags) {
      tagsAgrupadas.putIfAbsent(tag.grupo, () => []).add(tag);
    }

    return Scaffold(
      appBar: AppBar(title: Text("# Gerenciamento Tags"), backgroundColor: Colors.orange),
      body: _todasAsTags.isEmpty
          ? Center(child: Text("Crie seu primeiro grupo de tags!"))
          : ListView(
        padding: EdgeInsets.all(16),
        children: tagsAgrupadas.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(entry.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 0,
                children: [
                  // Adicionamos o .toList() e garantimos que são Widgets
                  ...entry.value.map<Widget>((tag) => InputChip( // Trocado para InputChip
                    label: Text(tag.nome),
                    onPressed: () => _mostrarDialogoTag(tagExistente: tag),
                    onDeleted: () { // Agora o onDeleted vai funcionar!
                      setState(() {
                        _todasAsTags.remove(tag);
                      });
                      _salvarEAtualizar();
                    },
                    deleteIconColor: Colors.red[300], // Deixa o 'x' mais suave
                  )).toList(), // O .toList() é fundamental aqui!

                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: const Text("Adicionar"),
                    onPressed: () => _mostrarDialogoTag(grupoSugerido: entry.key),
                    backgroundColor: Colors.amber.withOpacity(0.3),
                  ),
                ],
              ),
              Divider(height: 30),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogoTag(),
        label: Text("Novo Grupo"),
        icon: Icon(Icons.grid_view),
        backgroundColor: Colors.orange,
      ),
    );
  }
}