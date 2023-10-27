// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:app_folha_pagamento/models/Cargos.dart';
import 'package:app_folha_pagamento/pages/cargos/cadastro_cargo.dart';
import 'package:app_folha_pagamento/pages/cargos/editar_cargo.dart';
import 'package:app_folha_pagamento/pages/home_page.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/cargo_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';

class HomeCargosPage extends StatefulWidget {
  const HomeCargosPage({Key? key}) : super(key: key);

  @override
  State<HomeCargosPage> createState() => _HomeCargosPageState();
}

class _HomeCargosPageState extends State<HomeCargosPage> {
  late Future<List<Cargos>> cargos;

  final CargoService cargoService = CargoService();
  final UsuarioService usuarioService = UsuarioService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  @override
  void initState() {
    super.initState();
    cargos = recarregarDadosCargos();
    authMiddleware.checkAuthAndNavigate(context);
  }

  Future<List<Cargos>> recarregarDadosCargos() async {
    String? token = await usuarioService.getToken();
    return cargoService.obterCargos(token!);
  }

  Future<void> _confirmarExclusao(Cargos cargo) async {
    String? token = await usuarioService.getToken();

    if (token == null) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja realmente excluir este cargo?'),
          content: Text('Cargo: ${cargo.nome}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                try {
                  String? mensagem =
                      await cargoService.excluirCargo(cargo.id!, token);

                  if (mensagem == 'Cargo Deletado com sucesso') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mensagem!),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mensagem ?? 'Erro desconhecido'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (error) {
                  print('Erro ao excluir cargo: $error');
                }

                Navigator.of(context).pop();
                _recarregarCargos(); // Recarrega os dados de cargos
              },
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _recarregarCargos() {
    setState(() {
      cargos = recarregarDadosCargos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargos'),
        backgroundColor: const Color(0xFF008584),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<Cargos>>(
              future: cargos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoadingIndicator(); // Indicador de progresso personalizado
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum dado disponível'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Cargos cargo = snapshot.data![index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(cargo.nome!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => EditarCargo(
                                        cargoId: cargo.id!,
                                        recarregarDadosCargos:
                                            _recarregarCargos, // Passa a função de recarga
                                      ),
                                    ),
                                  )
                                      .then((value) {
                                    _recarregarCargos(); // Recarrega os dados após edição
                                  });
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmarExclusao(cargo);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF008584),
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const CadastroCargo(),
            ),
          )
              .then((value) {
            _recarregarCargos(); // Recarrega os dados de cargos após cadastro
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF008584)),
          ),
          SizedBox(height: 8),
          Text(
            'Carregando...',
            style: TextStyle(color: Color(0xFF008584)),
          ),
        ],
      ),
    );
  }
}
