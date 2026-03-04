import 'package:flutter/material.dart';
import '../models/roupa.dart'; // Importante para reconhecer a classe Roupa

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final TextEditingController _controleNome = TextEditingController();
  final TextEditingController _controleObs = TextEditingController();

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