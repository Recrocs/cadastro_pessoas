import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Map<String, dynamic>?> consultarCep(String cep) async {
    cep = cep.replaceAll('-', '');

    final url = Uri.parse(
      'https://viacep.com.br/ws/$cep/json/',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      if (dados['erro'] == true) {
        return null;
      }

      return dados;
    }

    return null;
  }
}