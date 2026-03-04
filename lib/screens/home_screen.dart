import 'package:flutter/material.dart';
import '../models/roupa.dart';
import 'cadastro_screen.dart';
// import 'inventario_screen.dart'; // Descomente quando criar este arquivo

class HomeGuardaRoupa extends StatefulWidget {
  @override
  State<HomeGuardaRoupa> createState() => _HomeGuardaRoupaState();
}

class _HomeGuardaRoupaState extends State<HomeGuardaRoupa> {
  List<Roupa> listaDeRoupas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1C4E9),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            Icon(Icons.door_sliding_outlined),
            SizedBox(width: 10),
            Text("Guarda Roupa"),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black54),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    listaDeRoupas.length.toString().padLeft(2, '0'),
                    style: TextStyle(fontSize: 80, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(width: 10),
                  Text("Roupas\nCadastradas", style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(color: Colors.grey[400]),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.black87,
                    padding: EdgeInsets.all(8),
                    child: Text("Adicionadas recentemente:",
                        style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaDeRoupas.length,
                      itemBuilder: (context, index) {
                        final roupa = listaDeRoupas[index];
                        return ListTile(
                          leading: Icon(Icons.checkroom, color: Colors.black54),
                          title: Text(roupa.nome, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(roupa.obs),
                          dense: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Navegação para Inventário virá aqui
            },
            backgroundColor: Colors.orange,
            child: Icon(Icons.inventory),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              final Roupa? resultado = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaCadastro()),
              );
              if (resultado != null) {
                setState(() {
                  listaDeRoupas.insert(0, resultado);
                });
              }
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.add, size: 40),
          ),
        ],
      ),
    );
  }
}