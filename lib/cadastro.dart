import 'package:flutter/material.dart';
import 'models/pessoa.dart';
import 'services/viacep_service.dart';
import 'services/storage_service.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final nomeController = TextEditingController();
  final cepController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();

  final ruaController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();

  final ViaCepService viaCepService = ViaCepService();
  final StorageService storageService = StorageService();

  bool carregando = false;

  Future<void> consultarCep() async {
    String cep = cepController.text;

    if (cep.isEmpty) {
      return;
    }

    setState(() {
      carregando = true;
    });

    final dados = await viaCepService.consultarCep(cep);

    setState(() {
      carregando = false;
    });

    if (dados != null) {
      ruaController.text = dados['logradouro'] ?? '';
      bairroController.text = dados['bairro'] ?? '';
      cidadeController.text = dados['localidade'] ?? '';
      estadoController.text = dados['uf'] ?? '';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CEP não encontrado.'),
        ),
      );
    }
  }

  Future<void> salvar() async {
    if (nomeController.text.isEmpty ||
        cepController.text.isEmpty ||
        numeroController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os campos obrigatórios.'),
        ),
      );

      return;
    }

    Pessoa pessoa = Pessoa(
      nome: nomeController.text,
      cep: cepController.text,
      rua: ruaController.text,
      numero: numeroController.text,
      complemento: complementoController.text,
      bairro: bairroController.text,
      cidade: cidadeController.text,
      estado: estadoController.text,
    );

    await storageService.salvarPessoa(pessoa);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro salvo com sucesso!'),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    cepController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cadastro'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'CEP',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: consultarCep,
                ),
              ),
              onSubmitted: (_) {
                consultarCep();
              },
            ),

            const SizedBox(height: 15),

            if (carregando)
              const Center(
                child: CircularProgressIndicator(),
              ),

            const SizedBox(height: 15),

            TextField(
              controller: ruaController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Rua',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: bairroController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Bairro',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: cidadeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Cidade',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: estadoController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: numeroController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: complementoController,
              decoration: const InputDecoration(
                labelText: 'Complemento',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: salvar,
              icon: const Icon(Icons.save),
              label: const Text('Salvar cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}