// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:app_folha_pagamento/models/Cargos.dart';
import 'package:app_folha_pagamento/models/Empresas.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/cargo_service.dart';
import 'package:app_folha_pagamento/services/colaborador_service.dart';
import 'package:app_folha_pagamento/services/empresa_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditarColaborador extends StatefulWidget {
  final int colaboradorId;
  final VoidCallback recarregarDadosColaborador;
  const EditarColaborador({
    required this.colaboradorId,
    required this.recarregarDadosColaborador,
    Key? key,
  }) : super(key: key);

  @override
  State<EditarColaborador> createState() => _EditarColaboradorState();
}

class _EditarColaboradorState extends State<EditarColaborador> {
  TextEditingController cpfController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController sobrenomeController = TextEditingController();
  TextEditingController salarioBaseController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController dataAdmissaoController = TextEditingController();
  TextEditingController dependentesController = TextEditingController();
  TextEditingController filhosController = TextEditingController();
  TextEditingController empresaIdController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController logradouroController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  int? cargoVinculado;
  int? empresaVinculada;

  List<Cargos> cargosList = [];
  List<Empresas> empresaList = [];

  int? selectedCargoId;
  int? selectedEmpresaId;

  String? feedbackMessage;
  final ColaboradorService colaboradorService = ColaboradorService();
  final CargoService cargoService = CargoService();
  final EmpresaService empresaService = EmpresaService();
  final UsuarioService usuarioService = UsuarioService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  DateFormat jsonDateFormat = DateFormat('yyyy-MM-dd');
  DateFormat inputDateFormat = DateFormat('dd/MM/yyyy');

  @override
  void dispose() {
    cpfController.dispose();
    nomeController.dispose();
    sobrenomeController.dispose();
    salarioBaseController.dispose();
    dataNascimentoController.dispose();
    dataAdmissaoController.dispose();
    dependentesController.dispose();
    filhosController.dispose();
    empresaIdController.dispose();
    cepController.dispose();
    logradouroController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _carregarDetalhesColaborador();
    _carregarCargos();
    _carregarEmpresas();
    selectedCargoId = cargosList.isNotEmpty ? cargosList[0].id : null;
    selectedEmpresaId = empresaList.isNotEmpty ? empresaList[0].id : null;
    authMiddleware.checkAuthAndNavigate(context);
  }

  Future<void> _editar() async {
    String novoCpf = cpfController.text;
    String novoNome = nomeController.text;
    String novoSobrenome = sobrenomeController.text;
    String novoSalarioBase = salarioBaseController.text;

    DateTime novaDataNascimento =
        inputDateFormat.parse(dataNascimentoController.text);
    DateTime novaDataAdmissao =
        inputDateFormat.parse(dataAdmissaoController.text);

    // Converter as datas para o formato "yyyy-MM-dd" para o JSON
    String dataNascimentoFormatted = jsonDateFormat.format(novaDataNascimento);
    String dataAdmissaoFormatted = jsonDateFormat.format(novaDataAdmissao);

    int novoDependentes = int.tryParse(dependentesController.text) ?? 0;
    int novoFilhos = int.tryParse(filhosController.text) ?? 0;
    int novoCargoId = selectedCargoId ?? 0;
    int novaEmpresaId = selectedEmpresaId ?? 0;
    String novoCep = cepController.text;
    String novoLogradouro = logradouroController.text;
    String novoNumero = numeroController.text;
    String novoBairro = bairroController.text;
    String novaCidade = cidadeController.text;
    String novoEstado = estadoController.text;
    String? token = await usuarioService.getToken();

    Map<String, dynamic> dadosColaborador = {
      "cpf": novoCpf,
      "nome": novoNome,
      "sobrenome": novoSobrenome,
      "salarioBase": novoSalarioBase,
      "dataNascimento": dataNascimentoFormatted,
      "dataAdmissao": dataAdmissaoFormatted,
      "dependentes": novoDependentes,
      "filhos": novoFilhos,
      "cargoId": novoCargoId,
      "empresaId": novaEmpresaId,
      "cep": novoCep,
      "logradouro": novoLogradouro,
      "numero": novoNumero,
      "bairro": novoBairro,
      "cidade": novaCidade,
      "estado": novoEstado,
    };

    String jsonDadosColaborador = jsonEncode(dadosColaborador);

    print('Dados do Colaborador (JSON):');
    print(jsonDadosColaborador);

    try {
      await colaboradorService.editarColaborador(
          widget.colaboradorId,
          novoCpf,
          novoNome,
          novoSobrenome,
          novoSalarioBase,
          dataNascimentoFormatted, 
          dataAdmissaoFormatted,
          novoDependentes,
          novoFilhos,
          novoCargoId,
          novaEmpresaId,
          novoCep,
          novoLogradouro,
          novoNumero,
          novoBairro,
          novaCidade,
          novoEstado,
          token!);

      setState(() {
        feedbackMessage = 'Colaborador Editado com Sucesso';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedbackMessage!),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(); 
      widget.recarregarDadosColaborador(); 
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

  Future<void> _buscarEnderecoPorCEP(String cep) async {
    try {
      final endereco = await colaboradorService.consultarCEP(cep);

      if (endereco.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(endereco['error']),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          logradouroController.text = endereco['logradouro'];
          bairroController.text = endereco['bairro'];
          cidadeController.text = endereco['cidade'];
          estadoController.text = endereco['estado'];
        });
      }
    } catch (error) {
      print('Erro ao buscar o endereço: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao buscar o endereço'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _carregarCargos() async {
    String? token = await usuarioService
        .getToken(); 
    try {
      final cargos = await cargoService.obterCargos(token!);
      setState(() {
        cargosList = cargos;
      });
    } catch (error) {
      print('Erro ao carregar cargos: $error');
    }
  }

  Future<void> _carregarEmpresas() async {
    String? token = await usuarioService.getToken();
    try {
      final empresas = await empresaService.obterEmpresas(token!);
      setState(() {
        empresaList = empresas;
      });
    } catch (error) {
      print('Erro ao carregar empresas: $error');
    }
  }

  Future<void> _carregarDetalhesColaborador() async {
    try {
      String? token = await usuarioService.getToken();
      final colaborador = await colaboradorService.obterColaboradoresPorId(
        widget.colaboradorId,
        token!,
      );

      setState(() {
        cpfController.text = colaborador.cpf ?? '';
        nomeController.text = colaborador.nome ?? '';
        sobrenomeController.text = colaborador.sobrenome ?? '';
        salarioBaseController.text = colaborador.salarioBase?.toString() ?? '';
        dataNascimentoController.text = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(colaborador.dataNascimento ?? ''));
        dataAdmissaoController.text = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(colaborador.dataAdmissao ?? ''));
        dependentesController.text = colaborador.dependentes?.toString() ?? '';
        filhosController.text = colaborador.filhos?.toString() ?? '';
        selectedCargoId = colaborador.cargoId;
        selectedEmpresaId = colaborador.empresaId;
        cepController.text = colaborador.cep ?? '';
        logradouroController.text = colaborador.logradouro ?? '';
        numeroController.text = colaborador.numero?.toString() ?? '';
        bairroController.text = colaborador.bairro ?? '';
        cidadeController.text = colaborador.cidade ?? '';
        estadoController.text = colaborador.estado ?? '';
      });
    } catch (error) {
      if (error is Exception) {
        print('Erro ao carregar detalhes do colaborador: $error');
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Colaborador'),
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
              keyboardType: TextInputType.number,
              controller: cpfController,
              decoration: const InputDecoration(
                labelText: "CPF",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
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
              keyboardType: TextInputType.name,
              controller: sobrenomeController,
              decoration: const InputDecoration(
                labelText: "Sobrenome",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: salarioBaseController,
              decoration: const InputDecoration(
                labelText: "Salário Base",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: dataNascimentoController,
              decoration: const InputDecoration(
                labelText: "Data de Nascimento",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: dataAdmissaoController,
              decoration: const InputDecoration(
                labelText: "Data de Admissão",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: dependentesController,
              decoration: const InputDecoration(
                labelText: "Dependentes",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: filhosController,
              decoration: const InputDecoration(
                labelText: "Filhos",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            DropdownButtonFormField<int>(
              value: cargosList.isNotEmpty ? selectedCargoId : null,
              onChanged: (int? cargoId) {
                setState(() {
                  selectedCargoId = cargoId;
                });
              },
              items: [
                if (cargosList.isEmpty)
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text("Nenhum cargo disponível"),
                  )
                else
                  ...cargosList.map((Cargos cargo) {
                    return DropdownMenuItem<int>(
                      value: cargo.id,
                      child: Text(cargo.nome!),
                    );
                  }).toList(),
              ],
              decoration: const InputDecoration(
                labelText: "Cargo",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            DropdownButtonFormField<int>(
              value: empresaList.isNotEmpty ? selectedEmpresaId : null,
              onChanged: (int? empresaId) {
                setState(() {
                  selectedEmpresaId = empresaId;
                });
              },
              items: [
                if (empresaList.isEmpty)
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text("Nenhuma empresa disponível"),
                  )
                else
                  ...empresaList.map((Empresas empresa) {
                    return DropdownMenuItem<int>(
                      value: empresa.id,
                      child: Text(empresa.nomeFantasia!),
                    );
                  }).toList(),
              ],
              decoration: const InputDecoration(
                labelText: "Empresa",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: cepController,
              decoration: const InputDecoration(
                labelText: "CEP",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              onChanged: (cep) {
                if (cep.length == 8) {
                  _buscarEnderecoPorCEP(cep);
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: logradouroController,
              decoration: const InputDecoration(
                labelText: "Logradouro",
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
              controller: numeroController,
              decoration: const InputDecoration(
                labelText: "Número",
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
              controller: bairroController,
              decoration: const InputDecoration(
                labelText: "Bairro",
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
              controller: cidadeController,
              decoration: const InputDecoration(
                labelText: "Cidade",
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
              controller: estadoController,
              decoration: const InputDecoration(
                labelText: "Estado",
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
