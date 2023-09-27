import 'dart:convert';

class Holerites {
  int? id;
  int? colaboradorId;
  int? mes;
  int? ano;
  int? horasNormais;
  int? horasExtras;
  int? tipo;

  Holerites(
      {this.id,
      this.colaboradorId,
      this.mes,
      this.ano,
      this.horasNormais,
      this.horasExtras,
      this.tipo});

  Holerites.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    colaboradorId = json['colaboradorId'];
    mes = json['mes'];
    ano = json['ano'];
    horasNormais = json['horasNormais'];
    horasExtras = json['horasExtras'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['colaboradorId'] = this.colaboradorId;
    data['mes'] = this.mes;
    data['ano'] = this.ano;
    data['horasNormais'] = this.horasNormais;
    data['horasExtras'] = this.horasExtras;
    data['tipo'] = this.tipo;

    return data;
  }
}
