import 'package:flutter/material.dart';
import '../models/roupa.dart'; // Importante para reconhecer a classe Roupa

class TelaCadastro extends StatefulWidget {
  final Roupa? roupaParaEditar; // Pode ser nulo se for um cadastro novo

  TelaCadastro({this.roupaParaEditar}); // Construtor opcional

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  late TextEditingController _controleNome;
  late TextEditingController _controleObs;

  @override
  void initState() {
    super.initState();
    // Se estiver editando, já começa com o texto da roupa antiga
    _controleNome = TextEditingController(text: widget.roupaParaEditar?.nome ?? "");
    _controleObs = TextEditingController(text: widget.roupaParaEditar?.obs ?? "");
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
      appBar: AppBar(title: Text("Cadastrar Roupa"), backgroundColor: Colors.green),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
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
                Roupa novaRoupa = Roupa(
                  nome: _controleNome.text,
                  obs: _controleObs.text,
                );
                Navigator.pop(context, novaRoupa);
              },
              child: Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}