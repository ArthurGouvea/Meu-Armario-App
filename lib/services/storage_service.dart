import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/roupa.dart';
import '../models/tag.dart';

class StorageService {
  static const String _key = 'lista_roupas';
  static const String _chaveTags = 'lista_tags';

  // SALVAR: Transforma a lista de objetos em uma String JSON e guarda
  static Future<void> salvarRoupas(List<Roupa> roupas) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> roupasString = roupas.map((r) => jsonEncode(r.toMap())).toList();
    await prefs.setStringList(_key, roupasString);
    print("DEBUG: Salvei ${roupasString.length} roupas no celular!"); // Adicione isso
  }

  // CARREGAR: Pega a String do celular e transforma de volta em objetos Roupa
  static Future<List<Roupa>> carregarRoupas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? roupasString = prefs.getStringList(_key);

    if (roupasString == null) return [];

    return roupasString.map((item) {
      return Roupa.fromMap(jsonDecode(item));
    }).toList();
  }

  Future<void> salvarTags(List<Tag> tags) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listaJson = tags.map((t) => jsonEncode(t.toMap())).toList();
    await prefs.setStringList(_chaveTags, listaJson);
  }

  Future<List<Tag>> carregarTags() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? listaJson = prefs.getStringList(_chaveTags);
    if (listaJson == null) return [];

    return listaJson.map((item) => Tag.fromMap(jsonDecode(item))).toList();
  }
}