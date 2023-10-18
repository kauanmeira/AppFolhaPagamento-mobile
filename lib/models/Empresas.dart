// ignore_for_file: file_names

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cnpj'] = cnpj;
    data['razaoSocial'] = razaoSocial;
    data['nomeFantasia'] = nomeFantasia;
    data['cep'] = cep;
    return data;
  }
}
