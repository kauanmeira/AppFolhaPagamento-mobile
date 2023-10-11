// ignore_for_file: file_names

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['colaboradorId'] = colaboradorId;
    data['mes'] = mes;
    data['ano'] = ano;
    data['horasNormais'] = horasNormais;
    data['horasExtras'] = horasExtras;
    data['tipo'] = tipo;

    return data;
  }
}
