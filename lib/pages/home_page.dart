// ignore_for_file: use_key_in_widget_constructors

import 'package:app_folha_pagamento/pages/cargos/home_cargos_page.dart';
import 'package:app_folha_pagamento/pages/colaboradores/home_colaboradores_page.dart';
import 'package:app_folha_pagamento/pages/holerites/home_holerites_page.dart';
import 'package:app_folha_pagamento/pages/login_page.dart';
import 'package:app_folha_pagamento/pages/usuarios/home_usuarios_page.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final UsuarioService usuarioService = UsuarioService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    authMiddleware.checkAuthAndNavigate(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008584),
        title: const Text('Bem vindo!'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Deseja realmente sair?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Feche o diálogo
                          Navigator.of(context).pop();
                        },
                        child: const Text('Não'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Feche o diálogo
                          Navigator.of(context).pop();
                          // Redirecione para a página de login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text('Sim'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeColaboradoresPage(),
                  ),
                );
              },
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.3, 1],
                    colors: [
                      Color(0xFF008584),
                      Color(0xFF007C70),
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Colaboradores",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeCargosPage(),
                  ),
                );
              },
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.3, 1],
                    colors: [
                      Color(0xFF008584),
                      Color(0xFF007C70),
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Cargos",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeUsuariosPage(),
                  ),
                );
              },
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.3, 1],
                    colors: [
                      Color(0xFF008584),
                      Color(0xFF007C70),
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Usuários",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeHoleritesPage(),
                    ),
                  );
                }
              },
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.3, 1],
                    colors: [
                      Color(0xFF008584),
                      Color(0xFF007C70),
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Holerites",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
