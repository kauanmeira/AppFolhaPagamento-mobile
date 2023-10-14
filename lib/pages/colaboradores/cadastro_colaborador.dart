import 'dart:convert';
import 'dart:io';
import 'package:app_folha_pagamento/models/Cargos.dart';
import 'package:app_folha_pagamento/models/Empresas.dart';
import 'package:app_folha_pagamento/pages/colaboradores/home_colaboradores_page.dart';
import 'package:app_folha_pagamento/pages/login_page.dart';
import 'package:app_folha_pagamento/services/HttpService.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/cargo_service.dart';
import 'package:app_folha_pagamento/services/colaborador_service.dart';
import 'package:app_folha_pagamento/services/empresa_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  TextEditingController empresaIdController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController logradouroController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();

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

  DateFormat inputDateFormat = DateFormat('dd/MM/yyyy');
  DateFormat displayDateFormat = DateFormat('dd/MM/yyyy');
  DateFormat jsonDateFormat = DateFormat('yyyy-MM-dd');

  @override
  void dispose() {
    // Dispose dos controladores
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
    authMiddleware.checkAuthAndNavigate(context);
    HttpOverrides.global = HttpService();
    _carregarCargos();
    _carregarEmpresas();
    selectedCargoId = null;
    dataNascimentoController.addListener(() {
      formatDateField(dataNascimentoController);
    });

    dataAdmissaoController.addListener(() {
      formatDateField(dataAdmissaoController);
    });
  }

  void formatDateField(TextEditingController controller) {
    final String text = controller.text;

    if (text.length == 2 && !text.contains('/')) {
      controller.text = '$text/';
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    } else if (text.length == 5 && !text.endsWith('/')) {
      controller.text = '$text/';
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  Future<void> _carregarCargos() async {
    String? token = await usuarioService
        .getToken(); // Obtenha o token aqui, dependendo de como você o está gerenciando.

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
      print('Erro ao carregar as empresas: $error');
    }
  }

  void _preencherEndereco(Map<String, dynamic> endereco) {
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
  }

  Future<void> _cadastrar() async {
    print('Cadastrando...');
    String cpf = cpfController.text;
    String nome = nomeController.text;
    String sobrenome = sobrenomeController.text;
    String salarioBase = salarioBaseController.text;
    DateFormat inputDateFormat = DateFormat('dd/MM/yyyy');
    DateFormat displayDateFormat = DateFormat('dd/MM/yyyy');
    DateFormat jsonDateFormat = DateFormat('yyyy-MM-dd');
    // Analise as datas no formato "dd/MM/yyyy"
    DateTime dataNascimento =
        inputDateFormat.parse(dataNascimentoController.text);
    DateTime dataAdmissao = inputDateFormat.parse(dataAdmissaoController.text);

    // Converter as datas para o formato "yyyy-MM-dd" para o JSON
    String dataNascimentoFormatted = jsonDateFormat.format(dataNascimento);
    String dataAdmissaoFormatted = jsonDateFormat.format(dataAdmissao);

    int dependentes = int.tryParse(dependentesController.text) ?? 0;
    int filhos = int.tryParse(filhosController.text) ?? 0;
    int cargoId = selectedCargoId ?? 0;
    int empresaId = selectedEmpresaId ?? 0;
    String cep = cepController.text;
    String logradouro = logradouroController.text;
    String numero = numeroController.text;
    String bairro = bairroController.text;
    String cidade = cidadeController.text;
    String estado = estadoController.text;

    String? token = await usuarioService.getToken();
    try {
      final feedbackMessageResult =
          await colaboradorService.cadastrarColaborador(
              cpf,
              nome,
              sobrenome,
              salarioBase,
              dataNascimentoFormatted,
              dataAdmissaoFormatted,
              dependentes,
              filhos,
              cargoId,
              empresaId,
              cep,
              logradouro,
              numero,
              bairro,
              cidade,
              estado,
              token!);

      setState(() {
        feedbackMessage = feedbackMessageResult;
      });

      if (feedbackMessageResult.toLowerCase().contains('sucesso')) {
        // Se o cadastro for bem-sucedido, redirecione para a HomeColaboradoresPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeColaboradoresPage(),
          ),
        );
      }
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
              backgroundColor:
                  feedbackMessage!.toLowerCase().contains('sucesso')
                      ? Colors.green
                      : Colors.red,
            )
          : SnackBar(content: Text('Erro desconhecido')),
    );
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
        SnackBar(
          content: Text('Erro ao buscar o endereço'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Função para verificar o token e redirecionar para a tela de login se estiver expirado
  Future<void> _checkTokenAndRedirect(BuildContext context) async {
    final token = await usuarioService.getToken();

    if (token != null && !usuarioService.isTokenExpired(token)) {
      // Token válido, não é necessário fazer nada
    } else {
      // Token expirado ou ausente, exiba uma mensagem e redirecione para a tela de login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sua sessão expirou, faça login novamente.'),
          backgroundColor: Colors.red,
        ),
      );

      // Redirecionar para a tela de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    _checkTokenAndRedirect(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de colaborador'),
        backgroundColor: Color(0xFF008584),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeColaboradoresPage(),
              ),
              (route) => false,
            );
          },
        ),
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
              onChanged: (value) {
                String formattedName = capitalizeFirstLetter(value);
                nomeController.value = nomeController.value.copyWith(
                  text: formattedName,
                  selection:
                      TextSelection.collapsed(offset: formattedName.length),
                );
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: sobrenomeController,
              decoration: InputDecoration(
                labelText: "Sobrenome",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              onChanged: (value) {
                String formattedName = capitalizeFirstLetter(value);
                sobrenomeController.value = sobrenomeController.value.copyWith(
                  text: formattedName,
                  selection:
                      TextSelection.collapsed(offset: formattedName.length),
                );
              },
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
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    // Atualizar o controlador com a data formatada na interface
                    dataNascimentoController.text =
                        displayDateFormat.format(pickedDate);
                  });
                }
              },
              onFieldSubmitted: (value) {
                // Validar e formatar a data quando o usuário submete o campo
                try {
                  DateTime parsedDate = inputDateFormat.parse(value);
                  dataNascimentoController.text =
                      displayDateFormat.format(parsedDate);
                } catch (e) {
                  // Lida com entradas inválidas aqui
                }
              },
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
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    dataAdmissaoController.text =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                  });
                }
              },
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
            DropdownButtonFormField<int>(
              value:
                  selectedCargoId, // Variável para armazenar o cargo selecionado
              onChanged: (int? cargoId) {
                setState(() {
                  selectedCargoId =
                      cargoId; // Atualize a variável quando o usuário selecionar um cargo
                });
              },
              items: cargosList.map((Cargos cargo) {
                return DropdownMenuItem<int>(
                  value: cargo.id, // Use o ID do cargo como valor
                  child: Text(cargo.nome!), // Exiba o nome do cargo no dropdown
                );
              }).toList(),
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
            DropdownButtonFormField<int>(
              value:
                  selectedEmpresaId, // Variável para armazenar o cargo selecionado
              onChanged: (int? empresaId) {
                setState(() {
                  selectedEmpresaId =
                      empresaId; // Atualize a variável quando o usuário selecionar um cargo
                });
              },
              items: empresaList.map((Empresas empresa) {
                return DropdownMenuItem<int>(
                  value: empresa.id, // Use o ID do cargo como valor
                  child: Text(empresa
                      .nomeFantasia!), // Exiba o nome do cargo no dropdown
                );
              }).toList(),
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
              onChanged: (cep) {
                if (cep.length == 8) {
                  // Chama a função de busca de endereço quando o CEP tiver 8 dígitos
                  _buscarEnderecoPorCEP(cep);
                }
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: logradouroController,
              decoration: InputDecoration(
                labelText: "Logradouro",
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
              controller: numeroController,
              decoration: InputDecoration(
                labelText: "Número",
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
              controller: bairroController,
              decoration: InputDecoration(
                labelText: "Bairro",
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
              controller: cidadeController,
              decoration: InputDecoration(
                labelText: "Cidade",
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
              controller: estadoController,
              decoration: InputDecoration(
                labelText: "Estado",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 30),
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
