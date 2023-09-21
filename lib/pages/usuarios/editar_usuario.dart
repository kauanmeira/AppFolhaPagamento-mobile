import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';

class EditarUsuario extends StatefulWidget {
  final int usuarioId;
  final void Function() recarregarDadosUsuarios;

  EditarUsuario({
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
      TextEditingController(); // Campo de confirmação de senha
  String? feedbackMessage;
  final UsuarioService usuarioService = UsuarioService();

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

    _carregarDetalhesUsuario();
  }

  Future<void> _editar() async {
    String novoNome = nomeController.text;
    String novoEmail = emailController.text;
    String novaSenha = senhaController.text;
    String confirmarSenha =
        confirmarSenhaController.text; // Obtenha a confirmação de senha

    if (!isSenhasIguais(novaSenha, confirmarSenha)) {
      // Verifique se as senhas coincidem
      setState(() {
        feedbackMessage = 'As senhas não coincidem.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedbackMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return; // Saia da função se as senhas não coincidirem
    }

    try {
      await usuarioService.editarUsuario(
          widget.usuarioId, novoNome, novoEmail, novaSenha);

      setState(() {
        feedbackMessage = 'Usuario Editado com Sucesso';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedbackMessage!),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(); // Fecha a página de edição
      widget.recarregarDadosUsuarios(); // Chame a função de recarregamento
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
    try {
      final usuario = await usuarioService.obterUsuarioPorId(widget.usuarioId);
      nomeController.text = usuario.nome!;
      emailController.text = usuario.email!;
      senhaController.text = usuario.senha!;
    } catch (error) {
      print('Erro ao carregar detalhes do usuario: $error');
      // Lidar com o erro, por exemplo, exibir uma mensagem ao usuário.
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
        backgroundColor: Color(0xFF008584),
        actions: [
          IconButton(
            onPressed: _editar,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(height: 20),
            TextFormField(
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
                labelText: "Email",
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
              obscureText: true,
              controller: senhaController,
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
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              controller:
                  confirmarSenhaController, // Campo de confirmação de senha
              decoration: InputDecoration(
                labelText: "Confirmar Senha",
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
                onPressed: _editar,
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
