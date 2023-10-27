// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:app_folha_pagamento/pages/login_page.dart';
import 'package:app_folha_pagamento/services/HttpService.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({Key? key});

  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();
  String? feedbackMessage;
  final UsuarioService usuarioService = UsuarioService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  String? selectedUserRole; 

  bool _obscureTextSenha =
      true; 
  bool _obscureTextConfirmarSenha =
      true; 

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    authMiddleware.checkAuthAndNavigate(context);

    HttpOverrides.global = HttpService();
  }

  bool isSenhaValida(String senha) {
    final senhaValidaRegExp = RegExp(r'^(?=.*[A-Z!@#$%^&*(),.?":{}|<>]).{6,}$');
    return senhaValidaRegExp.hasMatch(senha);
  }

  bool isSenhasIguais() {
    return senhaController.text == confirmarSenhaController.text;
  }

  bool isEmailValido(String email) {
    final emailValidoRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.\w{2,})$',
    );
    return emailValidoRegExp.hasMatch(email);
  }

  Future<void> _cadastrar() async {
    String nome = nomeController.text;
    String email = emailController.text;
    String senha = senhaController.text;
    String confirmarSenha = confirmarSenhaController.text;
    String? token = await usuarioService.getToken();

    if (!isSenhasIguais()) {
      setState(() {
        feedbackMessage = 'As senhas não coincidem.';
      });
    } else if (!isSenhaValida(senha)) {
      setState(() {
        feedbackMessage =
            'A senha deve ter pelo menos 6 caracteres e conter uma letra maiúscula OU um caractere especial.';
      });
    } else if (!isEmailValido(email)) {
      setState(() {
        feedbackMessage = 'Por favor, insira um e-mail válido.';
      });
    } else if (selectedUserRole == null ||
        (selectedUserRole != 'Admin' && selectedUserRole != 'User')) {
      setState(() {
        feedbackMessage =
            'Por favor, escolha o tipo de usuário (Admin ou User).';
      });
    } else {
      int permissaoId = selectedUserRole == 'Admin'
          ? 1
          : 2; 
      try {
        await usuarioService.cadastrarUsuario(
            nome, email, senha, token!, permissaoId);
        setState(() {
          feedbackMessage = 'Usuário Cadastrado com Sucesso';
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } catch (error) {
        setState(() {
          feedbackMessage = error.toString();
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
          : const SnackBar(content: Text('Erro desconhecido')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de usuário'),
        backgroundColor: const Color(0xFF008584),
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        color: Colors.white,
        child: ListView(
          children: [
            Center(
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/512/1177/1177568.png",
                width: 128,
                height: 128,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.name,
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: "Nome",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: senhaController,
              obscureText: _obscureTextSenha,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: const TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureTextSenha ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureTextSenha = !_obscureTextSenha;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: confirmarSenhaController,
              obscureText: _obscureTextConfirmarSenha,
              decoration: InputDecoration(
                labelText: "Confirmar Senha",
                labelStyle: const TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureTextConfirmarSenha
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureTextConfirmarSenha = !_obscureTextConfirmarSenha;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedUserRole,
              onChanged: (newValue) {
                setState(() {
                  selectedUserRole = newValue;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Admin',
                  child: Text('Admin'),
                ),
                DropdownMenuItem(
                  value: 'User',
                  child: Text('User'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: "Tipo de Usuário",
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
                onPressed: _cadastrar,
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
}
