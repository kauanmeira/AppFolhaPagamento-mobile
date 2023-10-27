// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:app_folha_pagamento/models/Holerites.dart';
import 'package:app_folha_pagamento/pages/holerites/detalhes_holerite_page.dart';
import 'package:app_folha_pagamento/pages/holerites/gerar_holerite_page.dart';
import 'package:app_folha_pagamento/pages/home_page.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/colaborador_service.dart';
import 'package:app_folha_pagamento/services/holerite_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';

class HomeHoleritesPage extends StatefulWidget {
  const HomeHoleritesPage({Key? key}) : super(key: key);

  @override
  State<HomeHoleritesPage> createState() => _HomeHoleritesPageState();
}

class _HomeHoleritesPageState extends State<HomeHoleritesPage> {
  late Future<List<Holerites>> holerites;
  final HoleriteService holeriteService = HoleriteService();
  final UsuarioService usuarioService = UsuarioService();
  final ColaboradorService colaboradorService = ColaboradorService();
  final AuthMiddleware authMiddleware = AuthMiddleware();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String? token;

  @override
  void initState() {
    super.initState();
    authMiddleware.checkAuthAndNavigate(context);
    holerites = _recarregarDadosHolerite(selectedMonth, selectedYear);
    _recarregarToken();
  }

  Future<void> _recarregarToken() async {
    token = await usuarioService.getToken();
  }

  Future<String> _getNomeCpfColaborador(int colaboradorId) async {
    String? token = await usuarioService.getToken();
    try {
      final colaborador = await colaboradorService.obterColaboradoresPorId(
          colaboradorId, token!);

      // Verifique se o colaborador não é nulo antes de acessar seus campos
      if (colaborador != null) {
        return '${colaborador.nome} ${colaborador.sobrenome} - CPF: ${colaborador.cpf}';
      } else {
        return 'Colaborador não encontrado';
      }
    } catch (error) {
      print('Erro ao obter nome e CPF do colaborador: $error');
      return 'Erro ao obter informações do colaborador';
    }
  }

  Future<List<Holerites>> _recarregarDadosHolerite(int month, int year) async {
    String? token = await usuarioService.getToken();
    return holeriteService.obterHoleritesPorMesAno(token!, month, year);
  }

  Future<void> _confirmarExclusao(Holerites holerite) async {
    String? token = await usuarioService.getToken();

    if (token == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja realmente excluir este holerite?'),
          content: Text(
              'Holerite: ${holerite.mes}/${holerite.ano}\nColaborador:${holerite.colaboradorId}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                try {
                  String? mensagem = await holeriteService.excluirHolerite(
                      holerite.id!, token);
                  if (mensagem != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mensagem),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.of(context).pop();

                    setState(() {
                      holerites =
                          _recarregarDadosHolerite(selectedMonth, selectedYear);
                    });
                  }
                } catch (error) {
                  print('Erro ao excluir usuário: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir usuário: $error'),
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
        title: const Text('Holerites'),
        backgroundColor: const Color(0xFF008584),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton<int>(
                value: selectedMonth,
                items: List<DropdownMenuItem<int>>.generate(12, (int index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text(meses[index]),
                  );
                }),
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      selectedMonth = value;
                      holerites =
                          _recarregarDadosHolerite(selectedMonth, selectedYear);
                    });
                  }
                },
              ),
              DropdownButton<int>(
                value: selectedYear,
                items: List<DropdownMenuItem<int>>.generate(10, (int index) {
                  return DropdownMenuItem<int>(
                    value: DateTime.now().year - index,
                    child: Text('${DateTime.now().year - index}'),
                  );
                }),
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      selectedYear = value;
                      holerites =
                          _recarregarDadosHolerite(selectedMonth, selectedYear);
                    });
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Holerites>>(
              future: holerites,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomLoadingIndicator();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum holerite disponível'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Holerites holerite = snapshot.data![index];
                      String tipoHolerite =
                          holerite.tipo == 1 ? 'Holerite' : '13º Salário';

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                              '$tipoHolerite - ${meses[holerite.mes! - 1]} ${holerite.ano}'),
                          subtitle: FutureBuilder<String>(
                            future:
                                _getNomeCpfColaborador(holerite.colaboradorId!),
                            builder: (context, colaboradorSnapshot) {
                              if (colaboradorSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('Carregando...');
                              } else if (colaboradorSnapshot.hasError) {
                                return const Text(
                                    'Erro ao carregar informações do colaborador');
                              } else {
                                return Text(colaboradorSnapshot.data ?? '');
                              }
                            },
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetalhesHoleritePage(
                                        holerite: holerite,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmarExclusao(holerite);
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
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const GerarHoleritePage(),
            ),
            (route) => false,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

final List<String> meses = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

class CustomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
