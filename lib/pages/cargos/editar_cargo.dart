import 'package:flutter/material.dart';
import 'package:app_folha_pagamento/services/cargo_service.dart';

class EditarCargo extends StatefulWidget {
  final int cargoId;
  final void Function() recarregarDadosCargos;

  EditarCargo({
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

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Carregue os detalhes do cargo para edição
    _carregarDetalhesCargo();
  }

  Future<void> _editar() async {
    String novoNome = nomeController.text;

    try {
      await cargoService.editarCargo(widget.cargoId, novoNome);

      setState(() {
        feedbackMessage = 'Cargo Editado com Sucesso';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedbackMessage!),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(); // Fecha a página de edição
      widget.recarregarDadosCargos(); // Chame a função de recarregamento
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
    try {
      final cargo = await cargoService.obterCargoPorId(widget.cargoId);
      nomeController.text = cargo.nome!;
    } catch (error) {
      print('Erro ao carregar detalhes do cargo: $error');
      // Lidar com o erro, por exemplo, exibir uma mensagem ao usuário.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cargo'),
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
