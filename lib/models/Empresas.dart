class Empresas {
  int? id;
  String? cnpj;
  String? razaoSocial;
  String? nomeFantasia;
  String? cep;

  Empresas({this.id, this.cnpj, this.razaoSocial, this.nomeFantasia, this.cep});

  Empresas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cnpj = json['cnpj'];
    razaoSocial = json['razaoSocial'];
    nomeFantasia = json['nomeFantasia'];
    cep = json['cep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cnpj'] = this.cnpj;
    data['razaoSocial'] = this.razaoSocial;
    data['nomeFantasia'] = this.nomeFantasia;
    data['cep'] = this.cep;
    return data;
  }
}
