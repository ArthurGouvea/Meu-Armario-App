import 'package:flutter/material.dart';
import '../models/roupa.dart';

class CardRoupa extends StatelessWidget {
  final Roupa roupa;
  final VoidCallback onTap; // Para editar
  final VoidCallback onLongPress; // Para deletar

  const CardRoupa({
    super.key,
    required this.roupa,
    required this.onTap,
    required this.onLongPress
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.checkroom, size: 50, color: Colors.orange),
              const SizedBox(height: 10),
              Text(roupa.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  roupa.obs,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      );
    }
}