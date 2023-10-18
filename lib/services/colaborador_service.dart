import 'dart:convert';
import 'package:app_folha_pagamento/models/Colaboradores.dart';
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
      String numero,
      String bairro,
      String cidade,
      String estado,
      String token) async {
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
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
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

  Future<List<Colaboradores>> obterColaboradoresAtivos(String token) async {
    var url = Uri.parse('$baseUrl/colaboradores/ativos');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List listaColaboradores = json.decode(response.body);
      return listaColaboradores
          .map((json) => Colaboradores.fromJson(json))
          .toList();
    } else {
      throw Exception('Erro, não foi possível carregar os colaboradores');
    }
  }

  Future<List<Colaboradores>> obterColaboradoresInativos(String token) async {
    var url = Uri.parse('$baseUrl/colaboradores/inativos');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List listaColaboradores = json.decode(response.body);
      return listaColaboradores
          .map((json) => Colaboradores.fromJson(json))
          .toList();
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

  Future<Colaboradores> obterColaboradoresPorId(int id, String token) async {
    try {
      var url = Uri.parse('$baseUrl/colaboradores/$id');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Colaboradores.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro, não foi possível carregar o colaborador por ID');
      }
    } catch (error) {
      throw 'Erro ao obter o colaborador por ID: $error';
    }
  }

  Future<void> editarColaborador(
    int id,
    String novoCpf,
    String novoNome,
    String novoSobrenome,
    String novoSalarioBase,
    String novaDataNascimento,
    String novaDataAdmissao,
    int novoDependentes,
    int novoFilhos,
    int novoCargoId,
    int novaEmpresaId,
    String novoCep,
    String novoLogradouro,
    String novoNumero,
    String novoBairro,
    String novaCidade,
    String novoEstado,
    String token,
  ) async {
    try {
      var url = Uri.parse('$baseUrl/colaboradores/$id');
      final response = await http.patch(
        url,
        body: jsonEncode({
          'cpf': novoCpf,
          'nome': novoNome,
          'sobrenome': novoSobrenome,
          'salarioBase': novoSalarioBase,
          'dataNascimento': novaDataNascimento,
          'dataAdmissao': novaDataAdmissao,
          'dependentes': novoDependentes,
          'filhos': novoFilhos,
          'cargoId': novoCargoId,
          'empresaId': novaEmpresaId,
          'cep': novoCep,
          'logradouro': novoLogradouro,
          'numero': novoNumero,
          'bairro': novoBairro,
          'cidade': novaCidade,
          'estado': novoEstado
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Adicione o token ao cabeçalho
        },
      );

      if (response.statusCode == 200) {
        // Lida com a resposta de sucesso, se necessário
      } else {
        throw 'Erro ao editar o colaborador. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao editar o colaborador: $error';
    }
  }

  Future<String?> demitirColaborador(int id, String token) async {
    try {
      var url = Uri.parse('$baseUrl/colaboradores/demitir/$id');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return 'Colaborador Demitido com sucesso';
      } else {
        // Verifique se a resposta contém uma mensagem de erro
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'] ?? 'Erro desconhecido';
        return errorMessage;
      }
    } catch (error) {
      return 'Erro ao demitir o colaborador: $error';
    }
  }

   Future<String?> ativarColaborador(int id, String token) async {
    try {
      var url = Uri.parse('$baseUrl/colaboradores/reativar/$id');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return 'Colaborador Ativado com sucesso';
      } else {
        // Verifique se a resposta contém uma mensagem de erro
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'] ?? 'Erro desconhecido';
        return errorMessage;
      }
    } catch (error) {
      return 'Erro ao ativar o colaborador: $error';
    }
  }
}
