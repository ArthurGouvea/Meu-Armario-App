import 'package:uuid/uuid.dart';

class Roupa {
  String id;
  String nome;
  String obs;
  String? imagemPath;
  List<String> tagIds;

  Roupa({
    String? id,
    required this.nome,
    required this.obs,
    this.imagemPath,
    List<String>? tagIds,
  })  : id = id ?? const Uuid().v4(),
        tagIds = tagIds ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'obs': obs,
      'imagemPath': imagemPath,
      'tagIds': tagIds,
    };
  }

  factory Roupa.fromMap(Map<String, dynamic> map) {
    return Roupa(
      id: map['id'],
      nome: map['nome'],
      obs: map['obs'],
      imagemPath: map['imagemPath'],
      // --- CORREÇÃO AQUI ---
      // Pegamos o valor, garantimos que é uma Lista e forçamos o tipo String nela
      tagIds: List<String>.from(map['tagIds'] ?? []),
    );
  }
}