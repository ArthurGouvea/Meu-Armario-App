import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/roupa.dart'; // Importante para reconhecer a classe Roupa

class TelaCadastro extends StatefulWidget {
  final Roupa? roupaParaEditar; // Pode ser nulo se for um cadastro novo

  TelaCadastro({this.roupaParaEditar}); // Construtor opcional

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final TextEditingController _controleNome = TextEditingController();
  final TextEditingController _controleObs = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imagemSelecionada; // Isso guarda o arquivo temporário da foto

  Future<void> _tirarFoto() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85, // Mantenha a qualidade boa
    );
    if (foto != null) {
      setState(() {
        _imagemSelecionada = foto;
      });
    }
  }



  @override
  void initState() {
    super.initState();

    if (widget.roupaParaEditar != null) {
      _controleNome.text = widget.roupaParaEditar!.nome;
      _controleObs.text = widget.roupaParaEditar!.obs;

      if (widget.roupaParaEditar!.imagemPath != null) {
        _imagemSelecionada = XFile(widget.roupaParaEditar!.imagemPath!);
      }
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
      appBar: AppBar(title: const Text("Cadastrar Roupa")),
      body: SingleChildScrollView( // <--- ADICIONE ISSO AQUI
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              GestureDetector(
                onTap: _tirarFoto,
                child: Container(
                  width: double.infinity,
                  height: 400, // Altura maior para combinar com fotos em pé
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Só aparece se não tiver foto
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _imagemSelecionada != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(_imagemSelecionada!.path),
                      fit: BoxFit.cover, // <--- MUDE PARA COVER
                      alignment: Alignment.center, // Centraliza a foto
                    ),
                  )
                      : const Icon(Icons.camera_alt, size: 50),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _controleNome,
                decoration: InputDecoration(labelText: "Nome da peça"),
              ),
              TextField(
                controller: _controleObs,
                decoration: InputDecoration(labelText: "Observações"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final novaRoupa = Roupa(
                    nome: _controleNome.text,
                    obs: _controleObs.text,
                    imagemPath: _imagemSelecionada
                        ?.path, // <--- Aqui passamos a foto!
                  );
                  Navigator.pop(context, novaRoupa);
                },
                child: Text("Salvar"),
                )
              ],
            ),
          ),
        ),
      );
    }

  }