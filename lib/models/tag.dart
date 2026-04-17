import 'package:uuid/uuid.dart';

class Tag {
  String id;
  String nome;
  String grupo;

  Tag({
    String? id,
    required this.nome,
    String? grupo, // Agora aceita nulo no construtor
  })  : id = id ?? const Uuid().v4(),
  // Se grupo for nulo ou apenas espaços, vira "Sem Grupo"
        grupo = (grupo == null || grupo.trim().isEmpty) ? "Sem Grupo" : grupo;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'grupo': grupo,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      nome: map['nome'],
      // Mesma lógica na hora de carregar do banco de dados
      grupo: (map['grupo'] == null || map['grupo'].toString().trim().isEmpty)
          ? "Sem Grupo"
          : map['grupo'],
    );
  }
}