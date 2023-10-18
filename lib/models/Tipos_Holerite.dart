// ignore_for_file: file_names

class TiposHolerite {
  int? id;
  String? tipoHolerite;

  TiposHolerite({this.id, this.tipoHolerite});

  TiposHolerite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipoHolerite = json['tipoHolerite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tipoHolerite'] = tipoHolerite;
    return data;
  }
}
