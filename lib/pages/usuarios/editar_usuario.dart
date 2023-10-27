// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';

class EditarUsuario extends StatefulWidget {
  final int usuarioId;
  final void Function() recarregarDadosUsuarios;

  const EditarUsuario({
    required this.usuarioId,
    required this.recarregarDadosUsuarios,
    Key? key,
  }) : super(key: key);

  @override
  State<EditarUsuario> createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmarSenhaController =
      TextEditingController(); 
  String? feedbackMessage;
  final UsuarioService usuarioService = UsuarioService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

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
    _carregarDetalhesUsuario();
  }

  Future<void> _editar() async {
    String novoNome = nomeController.text;
    String novoEmail = emailController.text;
    String novaSenha = senhaController.text;
    String confirmarSenha =
        confirmarSenhaController.text; 

    if (!isSenhasIguais(novaSenha, confirmarSenha)) {
      setState(() {
        feedbackMessage = 'As senhas não coincidem.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedbackMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return; 
    }
    String? token = await usuarioService.getToken();

    try {
      await usuarioService.editarUsuario(
          widget.usuarioId, novoNome, novoEmail, novaSenha, token!);

      setState(() {
        feedbackMessage = 'Usuario Editado com Sucesso';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedbackMessage!),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(); 
      widget.recarregarDadosUsuarios(); 
    } catch (error) {
      if (error is String) {
        setState(() {
          feedbackMessage = error;
        });
      } else {
        print('Erro ao fazer edição: $error');
        setState(() {
          feedbackMessage = 'Erro ao fazer edição: $error';
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedbackMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _carregarDetalhesUsuario() async {
    String? token = await usuarioService.getToken();
    try {
      final usuario =
          await usuarioService.obterUsuarioPorId(widget.usuarioId, token!);
      nomeController.text = usuario.nome!;
      emailController.text = usuario.email!;
      senhaController.text = usuario.senha!;
    } catch (error) {
      print('Erro ao carregar detalhes do usuario: $error');
    }
  }

  bool isSenhasIguais(String senha, String confirmacaoSenha) {
    return senha == confirmacaoSenha;
  }

  bool isSenhaValida(String senha) {
    final senhaValidaRegExp = RegExp(r'^(?=.*[A-Z!@#$%^&*(),.?":{}|<>]).{6,}$');
    return senhaValidaRegExp.hasMatch(senha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
        backgroundColor: const Color(0xFF008584),
        actions: [
          IconButton(
            onPressed: _editar,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        color: Colors.white,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            TextFormField(
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
                labelText: "Email",
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
              obscureText: true,
              controller: senhaController,
              decoration: const InputDecoration(
                labelText: "Senha",
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
              obscureText: true,
              controller:
                  confirmarSenhaController, 
              decoration: const InputDecoration(
                labelText: "Confirmar Senha",
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
                onPressed: _editar,
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
