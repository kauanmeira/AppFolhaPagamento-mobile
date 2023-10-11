import 'package:app_folha_pagamento/pages/usuarios/confirmar_codigo_redefinicao_senha_screen.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';

class EsqueciSenha extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final UsuarioService usuarioService = UsuarioService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Redefinição de Senha'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                // Gerar um código de verificação
                final verificationCode = usuarioService.generateVerificationCode();

                // Enviar o código por e-mail
                try {
                  await usuarioService.enviarEmailComCodigo(email, verificationCode);
                } catch (e) {
                  print('Erro ao enviar o código por e-mail: $e');
                  // Trate o erro apropriadamente, talvez exibindo uma mensagem de erro para o usuário.
                  return;
                }
/*
                // Redirecionar o usuário para a tela de confirmação
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmarCodigoRedefinicaoSenhaScreen(
                      email: email,
                      verificationCode: verificationCode,
                    ),
                  ),
                );
                */
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
