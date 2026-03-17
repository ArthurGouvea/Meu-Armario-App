import 'dart:convert';

class Roupa {
  String nome;
  String obs;

  Roupa({required this.nome, required this.obs});

  // Converte a Roupa para um Map (Dicionário)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'obs': obs,
    };
  }

  // Cria uma Roupa a partir de um Map
  factory Roupa.fromMap(Map<String, dynamic> map) {
    return Roupa(
      nome: map['nome'],
      obs: map['obs'],
    );
  }
}