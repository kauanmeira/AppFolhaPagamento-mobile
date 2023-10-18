// ignore_for_file: file_names

class Usuario {
  int? id;
  String? nome;
  String? email;
  String? senha;
  int? permissaoId;

  Usuario({this.id, this.nome, this.email, this.senha, this.permissaoId});

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    permissaoId = json['permissaoId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['email'] = email;
    data['senha'] = senha;
    data['permissaoId'] = permissaoId;
    return data;
  }
}