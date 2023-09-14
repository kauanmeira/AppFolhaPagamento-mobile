import 'dart:convert';
import 'package:app_folha_pagamento/models/Usuario.dart';
import 'package:app_folha_pagamento/pages/usuarios/cadastro_usuario.dart';
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
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {},
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
