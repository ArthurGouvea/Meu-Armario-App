import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/roupa.dart';
import '../models/tag.dart'; // Ajustado para o nome que criamos
import '../services/storage_service.dart';

class TelaCadastro extends StatefulWidget {
  final Roupa? roupaParaEditar;

  TelaCadastro({this.roupaParaEditar});

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  List<Tag> _tagsDisponiveis = [];
  List<String> _tagsSelecionadasIds = [];

  final TextEditingController _controleNome = TextEditingController();
  final TextEditingController _controleObs = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarTagsDoStorage();

    // Se estiver editando, preenchemos os campos com os dados existentes
    if (widget.roupaParaEditar != null) {
      _controleNome.text = widget.roupaParaEditar!.nome;
      _controleObs.text = widget.roupaParaEditar!.obs;
      _tagsSelecionadasIds = List.from(widget.roupaParaEditar!.tagIds);

      if (widget.roupaParaEditar!.imagemPath != null) {
        _imagemSelecionada = XFile(widget.roupaParaEditar!.imagemPath!);
      }
    }
  }

  void _carregarTagsDoStorage() async {
    final tags = await StorageService().carregarTags();
    setState(() {
      _tagsDisponiveis = tags;
    });
  }

  Future<void> _tirarFoto() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (foto != null) {
      setState(() {
        _imagemSelecionada = foto;
      });
    }
  }

  @override
  void dispose() {
    _controleNome.dispose();
    _controleObs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roupaParaEditar == null ? "Cadastrar Roupa" : "Editar Roupa"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- ÁREA DA FOTO ---
              GestureDetector(
                onTap: _tirarFoto,
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _imagemSelecionada != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(_imagemSelecionada!.path),
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.camera_alt, size: 50),
                ),
              ),
              const SizedBox(height: 20),

              // --- CAMPOS DE TEXTO ---
              TextField(
                controller: _controleNome,
                decoration: const InputDecoration(labelText: "Nome da peça"),
              ),
              TextField(
                controller: _controleObs,
                decoration: const InputDecoration(labelText: "Observações"),
              ),
              const SizedBox(height: 20),

              // --- SELEÇÃO DE TAGS ---
              const Text("Selecione as Tags:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _tagsDisponiveis.isEmpty
                  ? const Text("Nenhuma tag criada. Vá em Filtros > Engrenagem.")
                  : Wrap(
                spacing: 8,
                children: _tagsDisponiveis.map((tag) {
                  final bool estaSelecionada = _tagsSelecionadasIds.contains(tag.id);
                  return FilterChip(
                    label: Text(tag.nome),
                    selected: estaSelecionada,
                    onSelected: (bool selecionado) {
                      setState(() {
                        if (selecionado) {
                          _tagsSelecionadasIds.add(tag.id);
                        } else {
                          _tagsSelecionadasIds.remove(tag.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // --- BOTÃO SALVAR ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    if (_controleNome.text.isEmpty) return;

                    final roupaFinal = Roupa(
                      id: widget.roupaParaEditar?.id, // Mantém o ID se for edição!
                      nome: _controleNome.text,
                      obs: _controleObs.text,
                      tagIds: _tagsSelecionadasIds, // Salva os IDs das tags marcadas
                      imagemPath: _imagemSelecionada?.path,
                    );

                    Navigator.pop(context, roupaFinal);
                  },
                  child: const Text("Salvar", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}