// ignore_for_file: use_build_context_synchronously

import 'package:app_folha_pagamento/pages/holerites/gerar_holerite_page.dart';
import 'package:app_folha_pagamento/pages/home_page.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:app_folha_pagamento/models/Holerites.dart';
import 'package:app_folha_pagamento/services/holerite_service.dart';

class HomeHoleritesPage extends StatefulWidget {
  const HomeHoleritesPage({Key? key}) : super(key: key);

  @override
  State<HomeHoleritesPage> createState() => _HomeHoleritesPageState();
}

class _HomeHoleritesPageState extends State<HomeHoleritesPage> {
  late Future<List<Holerites>> holerites;
  final HoleriteService holeriteService = HoleriteService();
  final UsuarioService usuarioService = UsuarioService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  @override
  void initState() {
    super.initState();
    recarregarDadosHolerites();
    authMiddleware.checkAuthAndNavigate(context);
  }

  Future<void> recarregarDadosHolerites() async {
    String? token = await usuarioService.getToken();
    setState(() {
      holerites = holeriteService.obterHolerites(token!);
    });
  }

  Future<void> _confirmarExclusao(Holerites holerite) async {
    String? token = await usuarioService.getToken();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja realmente excluir este holerite?'),
          content: Text('Holerite: ${holerite.colaboradorId}'),
          actions: <Widget>[
            TextButton(
              child: Text('Sim'),
              onPressed: () async {
                try {
                  String? mensagem = await holeriteService.excluirHolerite(
                      holerite.id!, token!);
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
                    recarregarDadosHolerites();
                  }
                } catch (error) {
                  // Lida com erros ao excluir
                  print('Erro ao excluir holerite: $error');
                  // Exibe uma mensagem de erro se necessário
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir holerite: $error'),
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
        title: const Text('Holerites'),
        backgroundColor: Color(0xFF008584),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Holerites>>(
          future: holerites,
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
                  Holerites holerite = snapshot.data![index];
                  return ListTile(
                    title: Text(holerite.colaboradorId.toString()!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmarExclusao(holerite);
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
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => GerarHoleritePage(),
            ),
          )
              .then((value) {
            recarregarDadosHolerites();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
