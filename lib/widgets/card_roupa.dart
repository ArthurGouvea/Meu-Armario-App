import 'dart:io'; // IMPORTANTE para ler a foto do celular
import 'package:flutter/material.dart';
import '../models/roupa.dart';

class CardRoupa extends StatelessWidget {
  final Roupa roupa;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CardRoupa({
    super.key,
    required this.roupa,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Aqui está o relevo/sombra que você prefere
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // FOTO (ou ícone se não houver)
            Expanded(
              flex: 3,
              child: (roupa.imagemPath != null && roupa.imagemPath!.isNotEmpty)
                  ? Image.file(
                File(roupa.imagemPath!),
                fit: BoxFit.cover,
              )
                  : Container(
                color: Colors.grey[100],
                child: const Icon(
                    Icons.checkroom, size: 40, color: Colors.grey),
              ),
            ),
            // NOME
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                roupa.nome,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}