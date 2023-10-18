// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:app_folha_pagamento/pages/home_page.dart';

import 'package:app_folha_pagamento/services/HttpService.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  final UsuarioService usuarioService = UsuarioService();
  String? feedbackMessage;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    HttpOverrides.global = HttpService();
  }

  Future<void> _login() async {
    String email = emailController.text;
    String senha = senhaController.text;

    try {
      final usuario = await usuarioService.login(email, senha);

      if (usuario != null) {
        print('Login bem-sucedido! Resposta da API: $usuario');
        setState(() {
          feedbackMessage = 'Usuário Logado com Sucesso';
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (error) {
      print('Erro ao fazer login: $error');
      setState(() {
        feedbackMessage = error.toString();
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      feedbackMessage != null
          ? SnackBar(
              content: Text(feedbackMessage!),
              backgroundColor: feedbackMessage!.contains('Sucesso')
                  ? Colors.green
                  : Colors.red,
            )
          : const SnackBar(content: Text('Erro desconhecido')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.network(
                    "https://cdn-icons-png.flaticon.com/512/5348/5348208.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                    prefixIcon: Icon(Icons.email),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF008584), // Cor quando focado
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: senhaController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Senha",
                    prefixIcon: Icon(Icons.lock),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF008584), // Cor quando focado
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  width: double.infinity,
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
                    onPressed: _login,
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
