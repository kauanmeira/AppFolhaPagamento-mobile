import 'dart:io';
import 'package:app_folha_pagamento/pages/login_page.dart';
import 'package:app_folha_pagamento/services/HttpService.dart';
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

  bool _obscureTextSenha =
      true; // Variável para controlar a visibilidade da senha
  bool _obscureTextConfirmarSenha =
      true; // Variável para controlar a visibilidade da senha de confirmação

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
    HttpOverrides.global = HttpService();
  }

  bool isSenhaValida(String senha) {
    // A expressão regular foi atualizada para exigir 6 ou mais caracteres,
    // incluindo pelo menos uma letra maiúscula OU um caractere especial.
    final senhaValidaRegExp = RegExp(r'^(?=.*[A-Z!@#$%^&*(),.?":{}|<>]).{6,}$');
    return senhaValidaRegExp.hasMatch(senha);
  }

  bool isSenhasIguais() {
    return senhaController.text == confirmarSenhaController.text;
  }

  Future<void> _cadastrar() async {
    print('Cadastrando...');
    String nome = nomeController.text;
    String email = emailController.text;
    String senha = senhaController.text;
    String confirmarSenha = confirmarSenhaController.text;

    if (!isSenhasIguais()) {
      setState(() {
        feedbackMessage = 'As senhas não coincidem.';
      });
    } else if (!isSenhaValida(senha)) {
      setState(() {
        feedbackMessage =
            'A senha deve ter pelo menos 6 caracteres e conter uma letra maiúscula OU um caractere especial.';
      });
    } else {
      try {
        await usuarioService.cadastrarUsuario(nome, email, senha);
        setState(() {
          feedbackMessage = 'Usuário Cadastrado com Sucesso';
        });

        // Redireciona para a tela de login após o cadastro bem-sucedido
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
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
          : SnackBar(content: Text('Erro desconhecido')),
    );
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
            // Campo de senha com ícone de botão para mostrar/ocultar a senha
            TextFormField(
              keyboardType: TextInputType.text,
              controller: senhaController,
              obscureText: _obscureTextSenha,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
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
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: confirmarSenhaController,
              obscureText: _obscureTextConfirmarSenha,
              decoration: InputDecoration(
                labelText: "Confirmar Senha",
                labelStyle: TextStyle(
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