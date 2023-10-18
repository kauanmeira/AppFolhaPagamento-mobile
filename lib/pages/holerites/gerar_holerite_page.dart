// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:app_folha_pagamento/models/Tipos_Holerite.dart';
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
  int? selectedTiposHoleriteId;

  // Listas de objetos
  late List<Colaboradores> colaboradores = [];
  List<Holerites> holerites = [];
  List<TiposHolerite> tiposHoleriteList = [];

  int colaboradorId = 0;
  int mes = 1;
  int ano = DateTime.now().year;
  int horasNormais = 0;
  TextEditingController horasNormaisController = TextEditingController();
  TextEditingController anoController = TextEditingController();
  bool horasExtrasEnabled = false;
  int horasExtras = 0;
  int tipo = 0;

  @override
  void initState() {
    super.initState();
    _carregarTiposHolerite();
    _carregarColaboradores();
    _carregarHolerites();
    authMiddleware.checkAuthAndNavigate(context);
  }

  Future<void> _carregarColaboradores() async {
    String? token = await usuarioService.getToken();
    try {
      final listaColaboradores =
          await colaboradorService.obterColaboradoresAtivos(token!);
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

  Future<void> _carregarTiposHolerite() async {
    String? token = await usuarioService.getToken();
    try {
      final tiposHolerite = await holeriteService.obterTiposHolerite(token!);
      setState(() {
        tiposHoleriteList =
            tiposHolerite; // Corrigido para atribuir tiposHolerite
      });
    } catch (error) {
      print('Erro ao carregar tipos de holerite: $error');
    }
  }

  Future<void> _gerarHolerite() async {
    String? token = await usuarioService.getToken();

    try {
      print('Dados a serem enviados:');
      print('Colaborador ID: $colaboradorId');
      print('Ano: $ano');
      print('Mês: $mes');
      print('Horas Normais: $horasNormais');
      print('Horas Extras Habilitadas: $horasExtrasEnabled');
      if (horasExtrasEnabled) {
        print('Horas Extras: $horasExtras');
      }
      print('Tipo de Holerite ID: $selectedTiposHoleriteId');

      final String responseMessage = await holeriteService.gerarHolerite(
        colaboradorId: colaboradorId,
        mes: mes,
        ano: ano,
        horasNormais: horasNormais,
        horasExtrasEnabled: horasExtrasEnabled,
        horasExtras: horasExtras,
        tipo:
            selectedTiposHoleriteId!, // Usar a variável selectedTiposHoleriteId
        token: token!,
      );

      print('Resposta da geração de holerite: $responseMessage');

      final isSuccessful = responseMessage.toLowerCase().contains('sucesso');

      final scaffoldColor = isSuccessful ? Colors.green : Colors.red;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseMessage),
          backgroundColor: scaffoldColor,
        ),
      );

      if (isSuccessful) {
        // Redirecionar para a HomeHoleritesPage se o holerite for gerado com sucesso
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeHoleritesPage(),
          ),
        );
      }
    } catch (error) {
      print('Erro ao gerar holerite: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geração de Holerite'),
        backgroundColor: const Color(0xFF008584),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomeHoleritesPage(),
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
            Center(
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/512/189/189715.png",
                width: 128,
                height: 128,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Colaborador',
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      DropdownButton<int>(
                        value: colaboradorId,
                        items: colaboradores.map((colaborador) {
                          return DropdownMenuItem<int>(
                            value: colaborador.id,
                            child: SizedBox(
                              width: 250, // Largura desejada
                              child: Text(
                                '${colaborador.nome} ${colaborador.sobrenome}',
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            colaboradorId = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: anoController,
                        decoration: const InputDecoration(
                          labelText: "Ano",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mês',
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      DropdownButton<int>(
                        value: mes,
                        items: List<DropdownMenuItem<int>>.generate(12,
                            (int index) {
                          return DropdownMenuItem<int>(
                            value: index + 1,
                            child: SizedBox(
                              width: 100, // Largura desejada
                              child: Text(_nomeMes(index + 1)),
                            ),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            mes = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: horasNormaisController,
              decoration: const InputDecoration(
                labelText: "Horas normais",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int newValue = int.tryParse(value) ?? 0;
                if (newValue > 220) {
                  newValue = 220;
                  horasNormaisController.text = '220';
                }
                setState(() {
                  horasNormais = newValue;
                });
              },
            ),
            const SizedBox(height: 10),
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
                const Text('Horas Extras'),
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
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: selectedTiposHoleriteId,
              onChanged: (int? tiposHoleriteId) {
                setState(() {
                  selectedTiposHoleriteId = tiposHoleriteId;
                });
              },
              items: tiposHoleriteList.map((TiposHolerite tiposHolerite) {
                return DropdownMenuItem<int>(
                  value: tiposHolerite.id,
                  child: Text(tiposHolerite.tipoHolerite!),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: "Tipo",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [Color(0xFF008584), Color(0xFF007C70)],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: TextButton(
                onPressed: _gerarHolerite,
                child: const Text(
                  "Salvar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
