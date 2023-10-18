// ignore_for_file: file_names

class Cargos {
  int? id;
  String? nome;

  Cargos({
    this.id,
    this.nome,
  });

  Cargos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    return data;
  }

  @override
  String toString() => 'Cargos(id: $id, nome: $nome)';
}
