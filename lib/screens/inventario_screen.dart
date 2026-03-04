import 'package:flutter/material.dart';
import '../models/roupa.dart';
import '../widgets/card_roupa.dart'; // Vamos usar o widget que você criou

class TelaInventario extends StatelessWidget {
  final List<Roupa> roupas;

  // Construtor que recebe a lista
  TelaInventario({required this.roupas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Inventário"),
        backgroundColor: Colors.orange,
      ),
      body: roupas.isEmpty
          ? Center(
        child: Text(
          "Nenhum item no armário ainda!",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : GridView.builder(
        padding: EdgeInsets.all(15),
        // Aqui definimos as colunas
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,      // 2 colunas
          crossAxisSpacing: 10,   // Espaço horizontal entre cards
          mainAxisSpacing: 10,    // Espaço vertical entre cards
          childAspectRatio: 0.8,  // Proporção (altura x largura)
        ),
        itemCount: roupas.length,
        itemBuilder: (context, index) {
          // Usando o seu widget customizado para cada item da grade
          return CardRoupa(roupa: roupas[index]);
        },
      ),
    );
  }
}