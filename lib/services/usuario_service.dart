// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:app_folha_pagamento/models/Usuario.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class UsuarioService {
  final String baseUrl = 'https://192.168.0.240:7256/api';

  Future<void> cadastrarUsuario(String nome, String email, String senha,
      String token, int permissaoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuario'),
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'permissaoId': permissaoId,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
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
    final token = await getToken(); 

    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      List listaUsuarios = json.decode(response.body);
      return listaUsuarios.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception('Erro, não foi possível carregar os usuários');
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> login(String email, String senha) async {
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
        final token = usuarioJson['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return token; 
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

  Future<String?> excluirUsuario(int id, String token) async {
    try {
      var url = Uri.parse('$baseUrl/usuario/$id');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
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

  Future<Usuario> obterUsuarioPorId(int id, String token) async {
    try {
      var url = Uri.parse('$baseUrl/usuario/$id');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return Usuario.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro, não foi possível carregar o usuario por ID');
      }
    } catch (error) {
      throw 'Erro ao obter o usuario por ID: $error';
    }
  }

  Future<void> editarUsuario(int id, String novoNome, String novoEmail,
      String novaSenha, String token) async {
    try {
      var url = Uri.parse('$baseUrl/usuario/$id');
      final response = await http.put(
        url,
        body: jsonEncode(
            {'nome': novoNome, 'email': novoEmail, 'senha': novaSenha}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
      } else {
        throw 'Erro ao editar o usuario. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao editar o usuario: $error';
    }
  }

  bool isTokenExpired(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      if (decodedToken['exp'] != null) {
        final int exp = decodedToken['exp'];
        final DateTime expirationDate =
            DateTime.fromMillisecondsSinceEpoch(exp * 1000);

        return DateTime.now().isAfter(expirationDate);
      }

      return false; 
    } catch (e) {
      return true; 
    }
  }

  Future<int?> getUserPermission() async {
    String? token = await getToken();

    if (token != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final int? userPermission = decodedToken['permissionId'];

      return userPermission;
    }

    return null;
  }

  String generateVerificationCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  Future<void> enviarEmailComCodigo(String email, String codigo) async {
    final smtpServer = gmail('seu_email@gmail.com', 'sua_senha');

    final message = Message()
      ..from = const Address('seu_email@gmail.com', 'Seu Nome')
      ..recipients.add(email)
      ..subject = 'Código de Verificação'
      ..text = 'Seu código de verificação é: $codigo';

    try {
      final sendReport = await send(message, smtpServer);

      if (sendReport != null) {
        print('Email enviado com sucesso!');
      } else {
        print('Falha ao enviar o email.');
      }
    } catch (e) {
      print('Erro ao enviar o email: $e');
    }
  }
}
