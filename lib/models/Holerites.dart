// ignore_for_file: file_names

import 'package:app_folha_pagamento/models/Colaboradores.dart';

class Holerites {
  int? id;
  int? colaboradorId;
  int? mes;
  int? ano;
  double? horasNormais;
  double? horasExtras;
  int? tipo;
  double? salarioLiquido;
  double? salarioBruto;
  double? descontoINSS;
  double? descontoIRRF;
  int? dependentesHolerite;
  Colaboradores? colaborador;

  Holerites({
    this.id,
    this.colaboradorId,
    this.mes,
    this.ano,
    this.horasNormais,
    this.horasExtras,
    this.tipo,
    this.salarioLiquido,
    this.colaborador,
  });

  Holerites.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    colaboradorId = json['colaboradorId'];
    mes = json['mes'];
    ano = json['ano'];
    salarioBruto = json['salarioBruto'];
    descontoINSS = json['descontoINSS'];
    descontoIRRF = json['descontoIRRF'];
    dependentesHolerite = json['dependentesHolerite'];

    if (json['horasNormais'] != null && json['horasNormais'] is num) {
      horasNormais = (json['horasNormais'] as num).toDouble();
    } else {
      horasNormais = 0.0;
    }

    if (json['horasExtras'] != null && json['horasExtras'] is num) {
      horasExtras = (json['horasExtras'] as num).toDouble();
    } else {
      horasExtras = 0.0;
    }

    tipo = json['tipo'];

    if (json['salarioLiquido'] != null && json['salarioLiquido'] is num) {
      salarioLiquido = (json['salarioLiquido'] as num).toDouble();
    } else {
      salarioLiquido = 0.0;
    }

    colaborador =
        Colaboradores.fromJson(json['colaborador'] ?? <String, dynamic>{});
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
    data['salarioLiquido'] = salarioLiquido;
    data['salarioBruto'] = salarioBruto;
    data['descontoINSS'] = descontoINSS;
    data['descontoIRRF'] = descontoIRRF;
    data['dependentesHolerite'] = dependentesHolerite;
    return data;
  }
}
