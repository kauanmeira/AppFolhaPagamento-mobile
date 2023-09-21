import 'dart:convert';
import 'package:app_folha_pagamento/models/Usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  final String baseUrl = 'https://192.168.0.240:7256/api';

  Future<void> cadastrarUsuario(String nome, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuario'),
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final usuarioJson = json.decode(response.body);
        return usuarioJson;
      } else if (response.statusCode == 400) {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'];
        throw errorMessage ?? 'Erro ao cadastrar o Usuario';
      } else {
        throw 'Erro ao cadastrar o Usuario. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao cadastrar o usuario: $error';
    }
  }

  Future<List<Usuario>> obterUsuarios() async {
    var url = Uri.parse('$baseUrl/usuario');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List listaUsuarios = json.decode(response.body);
      return listaUsuarios.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception('Erro, não foi possível carregar os usuários');
    }
  }

  Future<Map<String, dynamic>> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final usuarioJson = json.decode(response.body);
        return usuarioJson;
      } else if (response.statusCode == 401) {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'];
        throw errorMessage ?? 'Erro ao fazer login';
      } else {
        throw 'Erro ao fazer login. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao fazer login: $error';
    }
  }

  Future<String?> excluirUsuario(int id) async {
    try {
      var url = Uri.parse('$baseUrl/usuario/$id');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return 'Usuario Deletado com sucesso';
      } else {
        throw 'Erro ao excluir o usuario. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao excluir o usuario: $error';
    }
  }

  Future<Usuario> obterUsuarioPorId(int id) async {
    try {
      var url = Uri.parse('$baseUrl/usuario/$id');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return Usuario.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro, não foi possível carregar o usuario por ID');
      }
    } catch (error) {
      throw 'Erro ao obter o usuario por ID: $error';
    }
  }

  Future<void> editarUsuario(
      int id, String novoNome, String novoEmail, String novaSenha) async {
    try {
      var url = Uri.parse('$baseUrl/usuario/$id');
      final response = await http.put(
        url,
        body: jsonEncode(
            {'nome': novoNome, 'email': novoEmail, 'senha': novaSenha}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
      } else {
        throw 'Erro ao editar o usuario. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao editar o usuario: $error';
    }
  }
}
