import 'dart:io';

import 'package:app_folha_pagamento/pages/home_page.dart';
import 'package:app_folha_pagamento/pages/login_page.dart';
import 'package:app_folha_pagamento/services/HttpService.dart';
import 'package:app_folha_pagamento/services/cargo_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';

class CadastroCargo extends StatefulWidget {
  const CadastroCargo({Key? key});

  @override
  _CadastroCargoState createState() => _CadastroCargoState();
}

class _CadastroCargoState extends State<CadastroCargo> {
  TextEditingController nomeController = TextEditingController();
  String? feedbackMessage;
  final CargoService cargoService = CargoService();
  final UsuarioService usuarioService = UsuarioService();

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = HttpService();
  }

  Future<void> _cadastrar() async {
    print('Cadastrando...');
    String nome = nomeController.text;

    // Obtenha o token de onde você o gerencia, por exemplo, de uma variável de estado
    String? token = await usuarioService
        .getToken(); // Obtenha o token aqui, dependendo de como você o está gerenciando.

    try {
      final cargoCadastrado = await cargoService.cadastrarCargo(nome, token!);

      if (cargoCadastrado != null) {
        print('Cargo Cadastrado! Resposta da API: $cargoCadastrado');
        setState(() {
          feedbackMessage = 'Cargo Cadastrado com Sucesso';
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (error) {
      if (error is String) {
        setState(() {
          feedbackMessage = error;
        });
      } else {
        print('Erro ao fazer Cadastro: $error');
        setState(() {
          feedbackMessage = 'Erro ao fazer Cadastro: $error';
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      feedbackMessage != null
          ? SnackBar(
              content: Text(feedbackMessage!),
              backgroundColor: feedbackMessage!.contains('Sucesso')
                  ? Colors.green
                  : Colors.red,
            )
          : SnackBar(content: Text('Erro desconhecido')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Cargo'),
        backgroundColor: Color(0xFF008584),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        color: Colors.white,
        child: ListView(
          children: [
            Center(
              child: Image.network(
                "https://www.guarulhoscontabilidade.com.br/wp-content/uploads/2019/03/ICONE_DEPARTAMENTO_PESSOAL.png",
                width: 128,
                height: 128,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.name,
              controller: nomeController,
              decoration: InputDecoration(
                labelText: "Nome",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
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
                onPressed: _cadastrar,
                child: Text(
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
}
