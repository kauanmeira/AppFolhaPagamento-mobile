// ignore_for_file: library_private_types_in_public_api

import 'package:app_folha_pagamento/pages/holerites/home_holerites_page.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:flutter/material.dart';
import 'package:app_folha_pagamento/models/Colaboradores.dart';
import 'package:app_folha_pagamento/models/Holerites.dart';
import 'package:app_folha_pagamento/services/colaborador_service.dart';
import 'package:app_folha_pagamento/services/holerite_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';

class GerarHoleritePage extends StatefulWidget {
  const GerarHoleritePage({Key? key}) : super(key: key);

  @override
  _GerarHoleritePageState createState() => _GerarHoleritePageState();
}

class _GerarHoleritePageState extends State<GerarHoleritePage> {
  final HoleriteService holeriteService = HoleriteService();
  final ColaboradorService colaboradorService = ColaboradorService();
  final UsuarioService usuarioService = UsuarioService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  late List<Colaboradores> colaboradores = [];
  List<Holerites> holerites = [];
  int colaboradorId = 0;
  int mes = 1; // O mês começa em janeiro (1)
  int ano = DateTime.now().year;
  int horasNormais = 0;
  bool horasExtrasEnabled = false;
  int horasExtras = 0;
  int tipo = 0;

  @override
  void initState() {
    super.initState();
    _carregarColaboradores();
    _carregarHolerites();
    authMiddleware.checkAuthAndNavigate(context);
  }

  Future<void> _carregarColaboradores() async {
    String? token = await usuarioService.getToken();
    try {
      final listaColaboradores =
          await colaboradorService.obterColaboradores(token!);
      setState(() {
        colaboradores = listaColaboradores;
        colaboradorId =
            (listaColaboradores.isNotEmpty ? listaColaboradores[0].id : 0)!;
      });
    } catch (error) {
      print('Erro ao carregar colaboradores: $error');
    }
  }

  Future<void> _carregarHolerites() async {
    String? token = await usuarioService.getToken();
    try {
      final listaHolerites = await holeriteService.obterHolerites(token!);
      setState(() {
        holerites = listaHolerites;
      });
    } catch (error) {
      print('Erro ao carregar holerites: $error');
    }
  }

  Future<void> _gerarHolerite() async {
    String? token = await usuarioService.getToken();

    try {
      final Holerites holerite = await holeriteService.gerarHolerite(
          colaboradorId: colaboradorId,
          mes: mes,
          ano: ano,
          horasNormais: horasNormais,
          horasExtrasEnabled: horasExtrasEnabled,
          horasExtras: horasExtras,
          tipo: tipo,
          token: token!);

      // Faça algo com o holerite gerado, como exibir um resumo ou uma confirmação.
    } catch (error) {
      print('Erro ao gerar holerite: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geração de Holerite'),
        backgroundColor: Color(0xFF008584),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeHoleritesPage(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Colaborador:'),
            DropdownButton<int>(
              value: colaboradorId,
              items: colaboradores.map((colaborador) {
                return DropdownMenuItem<int>(
                  value: colaborador.id,
                  child: Text('${colaborador.nome} ${colaborador.sobrenome}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  colaboradorId = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Mês:'),
            DropdownButton<int>(
              value: mes,
              items: List<DropdownMenuItem<int>>.generate(12, (int index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text(_nomeMes(index + 1)),
                );
              }),
              onChanged: (value) {
                setState(() {
                  mes = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Ano:'),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  ano = int.tryParse(value) ?? DateTime.now().year;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Horas Normais:'),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  horasNormais = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Checkbox(
                  value: horasExtrasEnabled,
                  onChanged: (value) {
                    setState(() {
                      horasExtrasEnabled = value!;
                    });
                  },
                ),
                Text('Horas Extras'),
              ],
            ),
            if (horasExtrasEnabled)
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    horasExtras = int.tryParse(value) ?? 0;
                  });
                },
              ),
            SizedBox(height: 16),
            Text('Tipo:'),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  tipo = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _gerarHolerite,
              child: Text('Gerar Holerite'),
            ),
          ],
        ),
      ),
    );
  }

  String _nomeMes(int numeroMes) {
    switch (numeroMes) {
      case 1:
        return 'Janeiro';
      case 2:
        return 'Fevereiro';
      case 3:
        return 'Março';
      case 4:
        return 'Abril';
      case 5:
        return 'Maio';
      case 6:
        return 'Junho';
      case 7:
        return 'Julho';
      case 8:
        return 'Agosto';
      case 9:
        return 'Setembro';
      case 10:
        return 'Outubro';
      case 11:
        return 'Novembro';
      case 12:
        return 'Dezembro';
      default:
        return 'Mês Inválido';
    }
  }
}
