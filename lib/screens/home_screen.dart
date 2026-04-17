import 'package:flutter/material.dart';
import '../models/roupa.dart';
import '../services/storage_service.dart';
import 'cadastro_screen.dart';
import 'inventario_screen.dart'; // Descomente quando criar este arquivo

class HomeGuardaRoupa extends StatefulWidget {
  @override
  State<HomeGuardaRoupa> createState() => _HomeGuardaRoupaState();
}

class _HomeGuardaRoupaState extends State<HomeGuardaRoupa> {
  // 1. A variável deve estar limpa
  List<Roupa> listaDeRoupas = [];

// 2. O initState chama o carregamento
  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

// 3. A função de carregar (Coloque esses prints para vermos no Chrome)
  void _carregarDadosIniciais() async {
    print("🟡 Tentando carregar...");
    final salvas = await StorageService.carregarRoupas();
    print("🟢 Itens recuperados: ${salvas.length}");

    setState(() {
      listaDeRoupas = salvas;
    });
  }

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
                              // Use APENAS o id único. Não use o index!
                              key: Key(roupa.id),

                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                // É vital que o item seja removido da lista dentro do setState
                                // exatamente como você fez aqui:
                                setState(() {
                                  listaDeRoupas.removeAt(index);
                                });

                                StorageService.salvarRoupas(listaDeRoupas);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${roupa.nome} removida")),
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
              heroTag: "btn_inventario",
              onPressed: () async {
                // 1. Abre o inventário e ESPERA (await) você voltar
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaInventario(roupas: listaDeRoupas),
                  ),
                );

                // 2. Quando você volta, atualiza a tela para mostrar o que mudou
                setState(() {});

                // 3. Salva no celular para garantir que edições/exclusões feitas lá fiquem guardadas
                StorageService.salvarRoupas(listaDeRoupas);
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.inventory),
            ),

            const SizedBox(height: 10),

            // --- BOTÃO VERDE (ADICIONAR) ---
            FloatingActionButton(
              heroTag: "btn_adicionar",
              onPressed: () async {
                final Roupa? resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaCadastro()),
                );

                if (resultado != null) {
                  setState(() {
                    listaDeRoupas.insert(0, resultado); // Adiciona no topo da lista
                  });
                  // SALVA NO DISCO PARA NÃO SUMIR NO REBOOT
                  await StorageService.salvarRoupas(listaDeRoupas);
                  print("DEBUG: Salvei a roupa com o caminho: ${resultado.imagemPath}");
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