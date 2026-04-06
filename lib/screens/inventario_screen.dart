import 'package:flutter/material.dart';
import '../models/roupa.dart';
import '../services/storage_service.dart';
import '../widgets/card_roupa.dart';
import 'cadastro_screen.dart';

class TelaInventario extends StatefulWidget {
  final List<Roupa> roupas;
  TelaInventario({required this.roupas});

  @override
  State<TelaInventario> createState() => _TelaInventarioState();
}

class _TelaInventarioState extends State<TelaInventario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Inventário"),
        backgroundColor: Colors.orange,
      ),
      body: widget.roupas.isEmpty
          ? const Center(child: Text("Nenhum item no armário!"))
          : GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: widget.roupas.length,
        itemBuilder: (context, index) {
          return CardRoupa(
            roupa: widget.roupas[index],
            onTap: () async {
              // EDITA E ATUALIZA NA HORA
              final Roupa? editada = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaCadastro(roupaParaEditar: widget.roupas[index]),
                ),
              );


              if (editada != null) {
                setState(() {
                  widget.roupas[index] = editada;
                });
                await StorageService.salvarRoupas(widget.roupas);
              }
            },

            onLongPress: () {
              // DIALOG DE EXCLUSÃO
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Excluir Peça"),
                  content: Text("Deseja remover ${widget.roupas[index].nome}?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          widget.roupas.removeAt(index);
                        });
                        await StorageService.salvarRoupas(widget.roupas);

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Item removido!")),
                        );
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
    );
  }
}