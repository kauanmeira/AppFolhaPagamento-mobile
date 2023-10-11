import 'package:flutter/material.dart';

class ConfirmarCodigoRedefinicaoSenhaScreen extends StatelessWidget {
  TextEditingController codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar Código de Redefinição de Senha'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: codigoController,
              decoration: InputDecoration(
                labelText: 'Código de 4 dígitos',
              ),
            ),
            SizedBox(height: 20),
ElevatedButton(
  onPressed: () {
    final enteredCode = codigoController.text;
    final verificationCode = 0;// Recupere o código gerado anteriormente;

    if (enteredCode == verificationCode) {
      // Os códigos coincidem, permita que o usuário redefina a senha.
      // Você pode redirecionar o usuário para uma nova tela para redefinir a senha.
    } else {
      // Os códigos não coincidem, exiba uma mensagem de erro para o usuário.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Código Incorreto'),
            content: Text('O código inserido está incorreto. Tente novamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo de erro.
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  },
  child: Text('Confirmar Código'),
),

          ],
        ),
      ),
    );
  }
}
