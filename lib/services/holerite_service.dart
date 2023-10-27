import 'dart:convert';
import 'package:app_folha_pagamento/models/Holerites.dart';
import 'package:app_folha_pagamento/models/Tipos_Holerite.dart';
import 'package:http/http.dart' as http;

class HoleriteService {
  final String baseUrl = 'https://192.168.0.240:7256/api';

  Future<List<Holerites>> obterHolerites(String token) async {
    var url = Uri.parse('$baseUrl/holerites');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        List listaEmpresas = json.decode(response.body);
        return listaEmpresas.map((json) => Holerites.fromJson(json)).toList();
      } else {
        return <Holerites>[];
      }
    } else {
      throw Exception('Erro, não foi possível carregar o Holerite');
    }
  }

  Future<List<TiposHolerite>> obterTiposHolerite(String token) async {
    var url = Uri.parse('$baseUrl/tiposholerite');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        List listaTiposHolerite = json.decode(response.body);
        return listaTiposHolerite
            .map((json) => TiposHolerite.fromJson(json))
            .toList();
      } else {
        return <TiposHolerite>[];
      }
    } else {
      throw Exception('Erro, não foi possível carregar os tipos de holerite');
    }
  }

  Future<String?> excluirHolerite(int id, String token) async {
    try {
      var url = Uri.parse('$baseUrl/holerites/$id');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return 'Holerite Deletado com sucesso';
      } else {
        throw 'Erro ao excluir o holerite. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao excluir o holerite: $error';
    }
  }

  Future<String> gerarHolerite({
    required int colaboradorId,
    required int mes,
    required int ano,
    required int horasNormais,
    required bool horasExtrasEnabled,
    int horasExtras = 0,
    required int tipo,
    required String token,
  }) async {
    try {
      var url = Uri.parse('$baseUrl/holerites');
      Map<String, dynamic> data = {
        'colaboradorId': colaboradorId,
        'mes': mes,
        'ano': ano,
        'horasNormais': horasNormais,
        'horasExtras': horasExtrasEnabled ? horasExtras : 0,
        'tipo': tipo,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        return 'Holerite cadastrado com sucesso';
      } else if (response.statusCode == 400) {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'];
        throw errorMessage ?? 'Erro ao cadastrar o holerite';
      } else {
        throw 'Erro ao cadastrar o holerite. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao cadastrar o holerite: $error';
    }
  }

  Future<String> obterNomeSobrenomeColaborador(
      int colaboradorId, String token) async {
    var url = Uri.parse('$baseUrl/colaboradores/$colaboradorId');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final colaborador = json.decode(response.body);
      final nome = colaborador['nome'];
      final sobrenome = colaborador['sobrenome'];
      return '$nome $sobrenome';
    } else {
      throw Exception('Erro ao obter o nome e sobrenome do colaborador');
    }
  }

  Future<List<Holerites>> obterHoleritesPorMesAno(
      String token, int month, int year) async {
    try {
      var url = Uri.parse('$baseUrl/holerites/filtro');
      url =
          Uri.https(url.authority, url.path, {'ano': '$year', 'mes': '$month'});

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          List listaHolerites = json.decode(response.body);
          return listaHolerites
              .map((json) => Holerites.fromJson(json))
              .toList();
        } else {
          return <Holerites>[];
        }
      } else {
        throw Exception('Erro ao carregar os Holerites filtrados');
      }
    } catch (error) {
      throw 'Erro ao filtrar Holerites: $error';
    }
  }
}
