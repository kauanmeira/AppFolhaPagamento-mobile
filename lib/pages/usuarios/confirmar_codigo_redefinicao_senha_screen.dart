// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, unrelated_type_equality_checks

import 'package:flutter/material.dart';

class ConfirmarCodigoRedefinicaoSenhaScreen extends StatelessWidget {
  TextEditingController codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Código de Redefinição de Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: codigoController,
              decoration: const InputDecoration(
                labelText: 'Código de 4 dígitos',
              ),
            ),
            const SizedBox(height: 20),
ElevatedButton(
  onPressed: () {
    final enteredCode = codigoController.text;
    const verificationCode = 0;// Recupere o código gerado anteriormente;

    if (enteredCode == verificationCode) {
      // Os códigos coincidem, permita que o usuário redefina a senha.
      // Você pode redirecionar o usuário para uma nova tela para redefinir a senha.
    } else {
      // Os códigos não coincidem, exiba uma mensagem de erro para o usuário.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Código Incorreto'),
            content: const Text('O código inserido está incorreto. Tente novamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo de erro.
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  },
  child: const Text('Confirmar Código'),
),

          ],
        ),
      ),
    );
  }
}
