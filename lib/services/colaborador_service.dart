import 'dart:convert';
import 'package:app_folha_pagamento/models/Colaboradores.dart';
import 'package:app_folha_pagamento/models/Usuario.dart';
import 'package:http/http.dart' as http;

class ColaboradorService {
  final String baseUrl = 'https://192.168.0.240:7256/api';

  Future<String> cadastrarColaborador(
      String cpf,
      String nome,
      String sobrenome,
      String salarioBase,
      String dataNascimento,
      String dataAdmissao,
      int dependentes,
      int filhos,
      int cargoId,
      int empresaId,
      String cep,
      String logradouro,
      int numero,
      String bairro,
      String cidade,
      String estado) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/colaboradores'),
        body: jsonEncode({
          'cpf': cpf,
          'nome': nome,
          'sobrenome': sobrenome,
          'salarioBase': salarioBase,
          'dataNascimento': dataNascimento,
          'dataAdmissao': dataAdmissao,
          'dependentes': dependentes,
          'filhos': filhos,
          'cargoId': cargoId,
          'empresaId': empresaId,
          'cep': cep,
          'logradouro': logradouro,
          'numero': numero,
          'bairro': bairro,
          'cidade': cidade,
          'estado': estado
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Se o colaborador foi cadastrado com sucesso, você pode retornar uma mensagem
        return 'Colaborador cadastrado com sucesso';
      } else if (response.statusCode == 400) {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'];
        throw errorMessage ?? 'Erro ao cadastrar o colaborador';
      } else {
        throw 'Erro ao cadastrar o colaborador. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao cadastrar o colaborador: $error';
    }
  }

  Future<List<Colaboradores>> obterColaboradores() async {
    var url = Uri.parse('$baseUrl/colaboradores');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List listaUsuarios = json.decode(response.body);
      return listaUsuarios.map((json) => Colaboradores.fromJson(json)).toList();
    } else {
      throw Exception('Erro, não foi possível carregar os colaboradores');
    }
  }

  Future<Map<String, dynamic>> consultarCEP(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.containsKey('erro')) {
        return {
          'error': 'CEP não encontrado',
        };
      } else {
        return {
          'logradouro': data['logradouro'],
          'bairro': data['bairro'],
          'cidade': data['localidade'],
          'estado': data['uf'],
        };
      }
    } else {
      throw Exception('Erro ao buscar o endereço');
    }
  }
}
