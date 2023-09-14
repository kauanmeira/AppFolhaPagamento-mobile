import 'dart:io';

import 'package:app_folha_pagamento/pages/colaboradores/home_colaboradores_page.dart';
import 'package:app_folha_pagamento/pages/login_page.dart';
import 'package:app_folha_pagamento/services/HttpService.dart';
import 'package:app_folha_pagamento/services/colaborador_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CadastroColaborador extends StatefulWidget {
  const CadastroColaborador({Key? key});

  @override
  _CadastroColaboradorState createState() => _CadastroColaboradorState();
}

class _CadastroColaboradorState extends State<CadastroColaborador> {
  TextEditingController cpfController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController sobrenomeController = TextEditingController();
  TextEditingController salarioBaseController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController dataAdmissaoController = TextEditingController();
  TextEditingController dependentesController = TextEditingController();
  TextEditingController filhosController = TextEditingController();
  TextEditingController cargoIdController = TextEditingController();
  TextEditingController empresaIdController = TextEditingController();
  TextEditingController cepController = TextEditingController();

  String? feedbackMessage;
  final ColaboradorService colaboradorService = ColaboradorService();

  @override
  void dispose() {
    nomeController.dispose();
    sobrenomeController.dispose();
    salarioBaseController.dispose();
    dataNascimentoController.dispose();
    dataAdmissaoController.dispose();
    dependentesController.dispose();
    filhosController.dispose();
    cargoIdController.dispose();
    empresaIdController.dispose();
    cepController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = HttpService();
  }

  Future<void> _cadastrar() async {
    print('Cadastrando...');
    String cpf = cpfController.text;
    String nome = nomeController.text;
    String sobrenome = sobrenomeController.text;
    String salarioBase = salarioBaseController.text;
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String dataNascimento =
        dateFormat.format(DateTime.parse(dataNascimentoController.text));
    String dataAdmissao =
        dateFormat.format(DateTime.parse(dataAdmissaoController.text));

    int dependentes = int.tryParse(dependentesController.text) ?? 0;
    int filhos = int.tryParse(filhosController.text) ?? 0;
    int cargoId = int.tryParse(cargoIdController.text) ?? 0;
    int empresaId = int.tryParse(empresaIdController.text) ?? 0;
    String cep = cepController.text;

    try {
      final feedbackMessageResult =
          await colaboradorService.cadastrarColaborador(
              cpf,
              nome,
              sobrenome,
              salarioBase,
              dataNascimento,
              dataAdmissao,
              dependentes,
              filhos,
              cargoId,
              empresaId,
              cep);

      // O resultado da função é a mensagem de feedback
      setState(() {
        feedbackMessage = feedbackMessageResult;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeColaboradoresPage(),
        ),
      );
    } catch (error) {
      if (error is String) {
        setState(() {
          feedbackMessage = error;
        });
      } else {
        print('Erro ao fazer Cadastro: $error');
        setState(() {
          feedbackMessage = 'Erro ao fazer Cadastro: $error';
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
        title: const Text('Cadastro de colaborador'),
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
              keyboardType: TextInputType.number,
              controller: cpfController,
              decoration: InputDecoration(
                labelText: "CPF",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
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
              controller: sobrenomeController,
              decoration: InputDecoration(
                labelText: "Sobrenome",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: salarioBaseController,
              decoration: InputDecoration(
                labelText: "Salário Base",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.datetime,
              controller: dataNascimentoController,
              decoration: InputDecoration(
                labelText: "Data de Nascimento",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.datetime,
              controller: dataAdmissaoController,
              decoration: InputDecoration(
                labelText: "Data de Admissão",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: dependentesController,
              decoration: InputDecoration(
                labelText: "Dependentes",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: filhosController,
              decoration: InputDecoration(
                labelText: "Filhos",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: cargoIdController,
              decoration: InputDecoration(
                labelText: "Cargo",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: empresaIdController,
              decoration: InputDecoration(
                labelText: "Empresa",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: cepController,
              decoration: InputDecoration(
                labelText: "CEP",
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
