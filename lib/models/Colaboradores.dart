class Colaboradores {
  int? id;
  String? cpf;
  String? nome;
  String? sobrenome;
  int? salarioBase;
  String? dataNascimento;
  String? dataAdmissao;
  int? dependentes;
  int? filhos;
  int? cargoId;
  int? empresaId;
  String? cep;

  Colaboradores(
      {this.id,
      this.cpf,
      this.nome,
      this.sobrenome,
      this.salarioBase,
      this.dataNascimento,
      this.dataAdmissao,
      this.dependentes,
      this.filhos,
      this.cargoId,
      this.empresaId,
      this.cep});

  Colaboradores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cpf = json['cpf'];
    nome = json['nome'];
    sobrenome = json['sobrenome'];
    salarioBase = json['salarioBase'];
    dataNascimento = json['dataNascimento'];
    dataAdmissao = json['dataAdmissao'];
    dependentes = json['dependentes'];
    filhos = json['filhos'];
    cargoId = json['cargoId'];
    empresaId = json['empresaId'];
    cep = json['cep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cpf'] = this.cpf;
    data['nome'] = this.nome;
    data['sobrenome'] = this.sobrenome;
    data['salarioBase'] = this.salarioBase;
    data['dataNascimento'] = this.dataNascimento;
    data['dataAdmissao'] = this.dataAdmissao;
    data['dependentes'] = this.dependentes;
    data['filhos'] = this.filhos;
    data['cargoId'] = this.cargoId;
    data['empresaId'] = this.empresaId;
    data['cep'] = this.cep;
    return data;
  }
}
