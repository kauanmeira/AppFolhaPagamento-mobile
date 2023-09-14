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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['permissaoId'] = this.permissaoId;
    return data;
  }
}