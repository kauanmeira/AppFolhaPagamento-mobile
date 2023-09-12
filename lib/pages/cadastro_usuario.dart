import 'dart:convert';

import 'package:app_folha_pagamento/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io'; // Importe a biblioteca dart:io

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({Key? key});

  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = MyHttpOverrides();
  }

  Future<void> _cadastrar() async {
    print('Cadastrando...');
    String nome = nomeController.text;
    String email = emailController.text;
    String senha = senhaController.text;

    Map<String, String> cadastroData = {
      'nome': nome,
      'email': email,
      'senha': senha,
    };

    try {
      final response = await http.post(
        Uri.parse('https://192.168.20.240:7256/api/usuario'),
        body: jsonEncode(
            cadastroData), // Certifique-se de importar 'dart:convert'.
        headers: {
          'Content-Type':
              'application/json', // Defina o tipo de mídia como JSON.
        },
      );

      if (response.statusCode == 200) {
        print('Usuário Cadastrado! Resposta da API: ${response.body}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        print(
            'Erro ao fazer Cadastro do usuario. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao fazer Cadastro: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de usuário'),
        backgroundColor: Color(0xFF008584),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        color: Colors.white,
        child: ListView(
          children: [
            Center(
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/512/3126/3126589.png",
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
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
