import 'dart:convert';
import 'package:app_folha_pagamento/models/Usuario.dart';
import 'package:app_folha_pagamento/pages/usuarios/cadastro_usuario.dart';
import 'package:app_folha_pagamento/pages/usuarios/editar_usuario.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeUsuariosPage extends StatefulWidget {
  const HomeUsuariosPage({Key? key}) : super(key: key);

  @override
  State<HomeUsuariosPage> createState() => _HomeUsuariosPageState();
}

class _HomeUsuariosPageState extends State<HomeUsuariosPage> {
  late Future<List<Usuario>> usuarios;
  final UsuarioService usuarioService = UsuarioService();

  @override
  void initState() {
    super.initState();
    usuarios = usuarioService.obterUsuarios();
  }

  Future<void> recarregarDadosUsuarios() async {
    setState(() {
      usuarios = usuarioService.obterUsuarios();
    });
  }

  Future<void> _confirmarExclusao(Usuario usuario) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja realmente excluir este usuário?'),
          content: Text('Usuario: ${usuario.email}'),
          actions: <Widget>[
            TextButton(
              child: Text('Sim'),
              onPressed: () async {
                try {
                  String? mensagem =
                      await usuarioService.excluirUsuario(usuario.id!);
                  if (mensagem != null) {
                    // Exibe a mensagem de sucesso
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mensagem),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Fecha o diálogo
                    Navigator.of(context).pop();

                    // Recarrega os dados após a exclusão
                    recarregarDadosUsuarios();
                  }
                } catch (error) {
                  // Lida com erros ao excluir
                  print('Erro ao excluir usuario: $error');
                  // Exibe uma mensagem de erro se necessário
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
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
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
        backgroundColor: Color(0xFF008584),
      ),
      body: Center(
        child: FutureBuilder<List<Usuario>>(
          future: usuarios,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (!snapshot.hasData) {
              return Text('Nenhum dado disponível');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Usuario usuario = snapshot.data![index];
                  return ListTile(
                    title: Text(usuario.nome!),
                    subtitle: Text(usuario.email!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
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
                                .then((value) {
                              // Após a edição, os dados serão recarregados automaticamente
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmarExclusao(
                                usuario); // Chame a função de confirmação
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF008584),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CadastroUsuario(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
