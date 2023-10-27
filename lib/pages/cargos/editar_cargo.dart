// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:app_folha_pagamento/services/cargo_service.dart';

class EditarCargo extends StatefulWidget {
  final int cargoId;
  final VoidCallback recarregarDadosCargos;
  const EditarCargo({
    required this.cargoId,
    required this.recarregarDadosCargos,
    Key? key,
  }) : super(key: key);

  @override
  State<EditarCargo> createState() => _EditarCargoState();
}

class _EditarCargoState extends State<EditarCargo> {
  TextEditingController nomeController = TextEditingController();
  String? feedbackMessage;
  final CargoService cargoService = CargoService();
  final UsuarioService usuarioService = UsuarioService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    authMiddleware.checkAuthAndNavigate(context);
    _carregarDetalhesCargo();
  }

  Future<void> _editar() async {
    String novoNome = nomeController.text;

    String? token = await usuarioService.getToken();

    try {
      await cargoService.editarCargo(widget.cargoId, novoNome, token!);

      setState(() {
        feedbackMessage = 'Cargo Editado com Sucesso';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedbackMessage!),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(); 
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

  Future<void> _carregarDetalhesCargo() async {
    String? token = await usuarioService.getToken();
    try {
      final cargo = await cargoService.obterCargoPorId(widget.cargoId, token!);
      nomeController.text = cargo.nome!;
    } catch (error) {
      print('Erro ao carregar detalhes do cargo: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cargo'),
        backgroundColor: const Color(0xFF008584),
        actions: [
          IconButton(
            onPressed: _editar,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
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
                borderRadius: BorderRadius.all(Radius.circular(5)),
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
