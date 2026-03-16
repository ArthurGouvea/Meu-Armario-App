import 'package:flutter/material.dart';
import '../models/roupa.dart';
import 'cadastro_screen.dart';
import 'inventario_screen.dart'; // Descomente quando criar este arquivo

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
                      style: TextStyle(
                          fontSize: 80, fontWeight: FontWeight.w300),
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

                            return Dismissible(
                              key: Key(roupa.nome + index.toString()),
                              // Chave única para o Flutter não se perder
                              direction: DismissDirection.endToStart,
                              // Só permite arrastar da direita para a esquerda
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                setState(() {
                                  listaDeRoupas.removeAt(index);
                                });
                                // Um aviso rápido no rodapé
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("${roupa.nome} removida")),
                                );
                              },
                              child: ListTile(
                                leading: Icon(
                                    Icons.checkroom, color: Colors.black54),
                                title: Text(roupa.nome, style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                                subtitle: Text(roupa.obs),
                                // Adicione ou verifique esta linha!
                                dense: true,
                                onTap: () async {
                                  // Ao clicar, abrimos a mesma tela, mas passando a roupa atual!
                                  final Roupa? editada = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TelaCadastro(roupaParaEditar: roupa),
                                    ),
                                  );

                                  if (editada != null) {
                                    setState(() {
                                      listaDeRoupas[index] =
                                          editada; // Substitui a antiga pela nova
                                    });
                                  }
                                },
                              ),
                            );
                          }
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
            // --- BOTÃO LARANJA (INVENTÁRIO) ---
            FloatingActionButton(
              onPressed: () async {
                // O 'await' faz o código esperar você fechar a tela de inventário
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaInventario(roupas: listaDeRoupas),
                  ),
                );
                // Quando você volta do inventário, o setState avisa a Home para se atualizar
                setState(() {});
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.inventory),
            ),

            const SizedBox(height: 10),

            // --- BOTÃO VERDE (ADICIONAR) ---
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
              child: const Icon(Icons.add, size: 40),
            ),
          ],
        ),
    );
  }
}