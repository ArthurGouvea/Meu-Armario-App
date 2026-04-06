class Roupa {
  String nome;
  String obs;
  String? imagemPath; // <--- Opcional, pois nem toda roupa terá foto de cara

  Roupa({required this.nome, required this.obs, this.imagemPath});

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'obs': obs,
      'imagemPath': imagemPath, // Salva o caminho no JSON
    };
  }

  factory Roupa.fromMap(Map<String, dynamic> map) {
    return Roupa(
      nome: map['nome'],
      obs: map['obs'],
      imagemPath: map['imagemPath'], // Lê do JSON
    );
  }
}