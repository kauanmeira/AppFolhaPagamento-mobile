import 'package:app_folha_pagamento/pages/login_page.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';

class AuthMiddleware {
  final UsuarioService usuarioService = UsuarioService();

  Future<bool> isUserAuthenticated() async {
    final token = await usuarioService.getToken();

    if (token != null) {
      return !usuarioService.isTokenExpired(token);
    }

    return false;
  }

  void checkAuthAndNavigate(BuildContext context) async {
    final isAuthenticated = await isUserAuthenticated();

    if (!isAuthenticated) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sessão Expirou'),
            content: Text('Sua sessão expirou. Faça login novamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
