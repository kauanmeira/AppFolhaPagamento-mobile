// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, avoid_print

import 'package:app_folha_pagamento/models/Usuario.dart';
import 'package:app_folha_pagamento/pages/cargos/home_cargos_page.dart';
import 'package:app_folha_pagamento/pages/home_page.dart';
import 'package:app_folha_pagamento/pages/usuarios/cadastro_usuario.dart';
import 'package:app_folha_pagamento/pages/usuarios/editar_usuario.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeUsuariosPage extends StatefulWidget {
  const HomeUsuariosPage({Key? key}) : super(key: key);

  @override
  State<HomeUsuariosPage> createState() => _HomeUsuariosPageState();
}

class _HomeUsuariosPageState extends State<HomeUsuariosPage> {
  late Future<List<Usuario>> usuarios;
  final UsuarioService usuarioService = UsuarioService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  @override
  void initState() {
    super.initState();
    usuarios = usuarioService.obterUsuarios();
    authMiddleware.checkAuthAndNavigate(context);
  }

  Future<void> recarregarDadosUsuarios() async {
    setState(() {
      usuarios = usuarioService.obterUsuarios();
    });
  }

  Future<void> _confirmarExclusao(Usuario usuario) async {
    String? token = await usuarioService.getToken();

    if (token == null) {
      return;
    }

    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final String? userIdLoggedIn = decodedToken['nameid'];

    if (userIdLoggedIn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível obter o ID do usuário logado.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (usuario.id == userIdLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você não pode excluir sua própria conta.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja realmente excluir este usuário?'),
          content: Text('Usuario: ${usuario.email}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                try {
                  String? mensagem =
                      await usuarioService.excluirUsuario(usuario.id!, token);
                  if (mensagem != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mensagem),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.of(context).pop();

                    if (usuario.id == userIdLoggedIn) {
                   
                    } else {
                      recarregarDadosUsuarios();
                    }
                  }
                } catch (error) {
                  print('Erro ao excluir usuario: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir usuario: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
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
            child: FutureBuilder<List<Usuario>>(
              future: usuarios,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoadingIndicator();
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
                      Usuario usuario = snapshot.data![index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(usuario.nome!),
                          subtitle: Text(usuario.email!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (context) => EditarUsuario(
                                            usuarioId: usuario.id!,
                                            recarregarDadosUsuarios:
                                                recarregarDadosUsuarios,
                                          ),
                                        ),
                                      )
                                      .then((value) {});
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmarExclusao(usuario);
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
              builder: (context) => const CadastroUsuario(),
            ),
          )
              .then((value) {
            recarregarDadosUsuarios();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
