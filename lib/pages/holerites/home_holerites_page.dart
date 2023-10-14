import 'package:flutter/material.dart';
import 'package:app_folha_pagamento/models/Holerites.dart';
import 'package:app_folha_pagamento/pages/holerites/detalhes_holerite_page.dart';
import 'package:app_folha_pagamento/pages/holerites/gerar_holerite_page.dart';
import 'package:app_folha_pagamento/pages/home_page.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
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
  final AuthMiddleware authMiddleware = AuthMiddleware();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    authMiddleware.checkAuthAndNavigate(context);
    holerites = _recarregarDadosHolerite(selectedMonth, selectedYear);
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

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja realmente excluir este holerite?'),
          content: Text(
              'Holerite: ${holerite.mes}/${holerite.ano}\nColaborador:${holerite.colaboradorId}'),
          actions: <Widget>[
            TextButton(
              child: Text('Sim'),
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

                    _recarregarDadosHolerite(selectedMonth, selectedYear);
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
        title: const Text('Holerites'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton<int>(
                value: selectedMonth,
                items: List<DropdownMenuItem<int>>.generate(12, (int index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text(meses[index]), // Use o nome do mês aqui
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
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Nenhum holerite disponível'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Holerites holerite = snapshot.data![index];
                      return Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Mês: ${holerite.mes}, Ano: ${holerite.ano}',
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetalhesHoleritePage(
                                                  holerite: holerite),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _confirmarExclusao(holerite);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Text(
                              'Horas Normais: ${holerite.horasNormais}, Horas Extras: ${holerite.horasExtras}'),
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
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => GerarHoleritePage(),
            ),
            (route) => false,
          );
        },
        child: Icon(Icons.add),
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
