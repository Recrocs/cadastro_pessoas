import 'package:flutter/material.dart';
import 'models/pessoa.dart';
import 'services/storage_service.dart';
import 'cadastro.dart';
import 'theme_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Pessoa> pessoas = [];

  final StorageService storageService = StorageService();

  @override
  void initState() {
    super.initState();

    carregarPessoas();
  }

  Future<void> carregarPessoas() async {
    List<Pessoa> lista =
        await storageService.buscarPessoas();

    setState(() {
      pessoas = lista;
    });
  }

  Future<void> abrirCadastro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Cadastro(),
      ),
    );

    carregarPessoas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro de Pessoas',
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.people,
                    size: 50,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Cadastro de Pessoas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text(
                'Início',
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ValueListenableBuilder<bool>(
              valueListenable: temaEscuro,
              builder: (context, escuro, child) {
                return ListTile(
                  leading: Icon(
                    escuro
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),

                  title: Text(
                    escuro
                        ? 'Modo claro'
                        : 'Modo escuro',
                  ),

                  onTap: () {
                    trocarTema();

                    Navigator.pop(context);
                  },
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.person_add,
              ),
              title: const Text(
                'Nova pessoa',
              ),
              onTap: () {
                Navigator.pop(context);

                abrirCadastro();
              },
            ),
          ],
        ),
      ),

      body: pessoas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma pessoa cadastrada.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: pessoas.length,
              itemBuilder: (context, index) {
                Pessoa pessoa = pessoas[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.person,
                      ),
                    ),

                    title: Text(
                      pessoa.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '${pessoa.rua}, ${pessoa.numero}\n'
                      '${pessoa.bairro} - '
                      '${pessoa.cidade}/${pessoa.estado}\n'
                      'CEP: ${pessoa.cep}',
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirCadastro,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
