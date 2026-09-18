import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pessoa.dart';

class StorageService {
  Future<void> salvarPessoa(Pessoa pessoa) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> pessoasSalvas =
        prefs.getStringList('pessoas') ?? [];

    pessoasSalvas.add(jsonEncode(pessoa.toMap()));

    await prefs.setStringList('pessoas', pessoasSalvas);
  }

  Future<List<Pessoa>> buscarPessoas() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> pessoasSalvas =
        prefs.getStringList('pessoas') ?? [];

    List<Pessoa> pessoas = [];

    for (String pessoaSalva in pessoasSalvas) {
      Map<String, dynamic> dados =
          jsonDecode(pessoaSalva);

      pessoas.add(Pessoa.fromMap(dados));
    }

    return pessoas;
  }
}