// ignore_for_file: file_names

class Colaboradores {
  int? id;
  String? cpf;
  String? nome;
  String? sobrenome;
  String? email;
  int? salarioBase;
  String? dataNascimento;
  String? dataAdmissao;
  String? dataDemissao;
  bool? ativo;
  int? dependentes;
  int? filhos;
  int? cargoId;
  int? empresaId;
  String? cep;
  String? logradouro;
  String? numero;
  String? bairro;
  String? cidade;
  String? estado;

  Colaboradores(
      {this.id,
      this.cpf,
      this.nome,
      this.sobrenome,
      this.email,
      this.salarioBase,
      this.dataNascimento,
      this.dataAdmissao,
      this.dataDemissao,
      this.ativo,
      this.dependentes,
      this.filhos,
      this.cargoId,
      this.empresaId,
      this.cep,
      this.logradouro,
      this.numero,
      this.bairro,
      this.cidade,
      this.estado});

  Colaboradores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cpf = json['cpf'];
    nome = json['nome'];
    sobrenome = json['sobrenome'];
    email = json['email'];
    salarioBase = json['salarioBase'];
    dataNascimento = json['dataNascimento'];
    dataAdmissao = json['dataAdmissao'];
    dataDemissao = json['dataDemissao'];
    ativo = json['ativo'];
    dependentes = json['dependentes'];
    filhos = json['filhos'];
    cargoId = json['cargoId'];
    empresaId = json['empresaId'];
    cep = json['cep'];
    logradouro = json['logradouro'];
    numero = json['numero'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cpf'] = cpf;
    data['nome'] = nome;
    data['sobrenome'] = sobrenome;
    data['email'] = email;
    data['salarioBase'] = salarioBase;
    data['dataNascimento'] = dataNascimento;
    data['dataAdmissao'] = dataAdmissao;
    data['dataDemissao'] = dataDemissao;
    data['ativo'] = ativo;
    data['dependentes'] = dependentes;
    data['filhos'] = filhos;
    data['cargoId'] = cargoId;
    data['empresaId'] = empresaId;
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['numero'] = numero;
    data['bairro'] = bairro;
    data['cidade'] = cidade;
    data['estado'] = estado;

    return data;
  }
}
