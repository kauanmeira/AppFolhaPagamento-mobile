import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:flutter/material.dart';
import 'package:app_folha_pagamento/models/Colaboradores.dart';
import 'package:app_folha_pagamento/pages/colaboradores/cadastro_colaborador.dart';
import 'package:app_folha_pagamento/pages/colaboradores/detalhes_colaborador_page.dart';
import 'package:app_folha_pagamento/pages/colaboradores/editar_colaborador.dart';
import 'package:app_folha_pagamento/pages/home_page.dart';
import 'package:app_folha_pagamento/services/colaborador_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';

class HomeColaboradoresPage extends StatefulWidget {
  const HomeColaboradoresPage({Key? key}) : super(key: key);

  @override
  State<HomeColaboradoresPage> createState() => _HomeColaboradoresPageState();
}

class _HomeColaboradoresPageState extends State<HomeColaboradoresPage> {
  late Future<List<Colaboradores>> colaboradores;
  final AuthMiddleware authMiddleware = AuthMiddleware();
  final ColaboradorService colaboradorService = ColaboradorService();
  final UsuarioService usuarioService = UsuarioService();

  bool mostrarInativos = false;

  @override
  void initState() {
    super.initState();
    colaboradores = recarregarDadosColaborador();
    authMiddleware.checkAuthAndNavigate(context);
  }

  Future<List<Colaboradores>> recarregarDadosColaborador() async {
    String? token = await usuarioService.getToken();
    if (mostrarInativos) {
      return colaboradorService.obterColaboradoresInativos(token!);
    } else {
      return colaboradorService.obterColaboradoresAtivos(token!);
    }
  }

  Future<void> _confirmarExclusao(Colaboradores colaborador) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja realmente demitir este colaborador?'),
          content: Text(
              'Colaborador: ${colaborador.nome} ${colaborador.sobrenome}\nCPF: ${colaborador.cpf}'),
          actions: <Widget>[
            TextButton(
              child: Text('Sim'),
              onPressed: () async {
                try {
                  String? token = await usuarioService.getToken();
                  String? mensagem = await colaboradorService
                      .demitirColaborador(colaborador.id!, token!);

                  if (mensagem == 'Colaborador Demitido com sucesso') {
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
                  print('Erro ao demitir colaborador: $error');
                }

                Navigator.of(context).pop();
                setState(() {
                  colaboradores = recarregarDadosColaborador();
                });
              },
            ),
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarAtivacao(Colaboradores colaborador) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Colaborador Inativo\nDeseja ativar e readmitir este colaborador?'),
          content: Text(
              'Colaborador: ${colaborador.nome} ${colaborador.sobrenome}\nCPF: ${colaborador.cpf}'),
          actions: <Widget>[
            TextButton(
              child: Text('Sim'),
              onPressed: () async {
                try {
                  String? token = await usuarioService.getToken();
                  String? mensagem = await colaboradorService.ativarColaborador(
                      colaborador.id!, token!);

                  if (mensagem == 'Colaborador Ativado com sucesso') {
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
                  print('Erro ao ativar colaborador: $error');
                }

                Navigator.of(context).pop();
                setState(() {
                  colaboradores = recarregarDadosColaborador();
                });
              },
            ),
            TextButton(
              child: Text('Não'),
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
        title: const Text('Colaboradores'),
        backgroundColor: Color(0xFF008584),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  Switch(
                    value: mostrarInativos,
                    onChanged: (value) {
                      setState(() {
                        mostrarInativos = value;
                        colaboradores = recarregarDadosColaborador();
                      });
                    },
                  ),
                  Text('Mostrar inativos'),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Colaboradores>>(
              future: colaboradores,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Nenhum dado disponível'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Colaboradores colaborador = snapshot.data![index];
                      return Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                    '${colaborador.nome} ${colaborador.sobrenome}'),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetalhesColaboradorPage(
                                                  colaborador: colaborador),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      if (mostrarInativos) {
                                        _confirmarAtivacao(colaborador);
                                      } else {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditarColaborador(
                                                  colaboradorId:
                                                      colaborador.id!,
                                                  recarregarDadosColaborador:
                                                      recarregarDadosColaborador,
                                                ),
                                              ),
                                            )
                                            .then((value) {});
                                      }
                                    },
                                  ),
                                  if (!mostrarInativos)
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _confirmarExclusao(colaborador);
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Text(colaborador.cpf!),
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
        backgroundColor: Color(0xFF008584),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CadastroColaborador(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
