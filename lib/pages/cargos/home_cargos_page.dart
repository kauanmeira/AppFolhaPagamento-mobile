import 'dart:convert';
import 'package:app_folha_pagamento/models/Cargos.dart';
import 'package:app_folha_pagamento/pages/cargos/cadastro_cargo.dart';
import 'package:app_folha_pagamento/services/cargo_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeCargosPage extends StatefulWidget {
  const HomeCargosPage({Key? key}) : super(key: key);

  @override
  State<HomeCargosPage> createState() => _HomeCargosPageState();
}

class _HomeCargosPageState extends State<HomeCargosPage> {
  late Future<List<Cargos>> cargos;
  final CargoService cargoService = CargoService();

  @override
  void initState() {
    super.initState();
    cargos = cargoService.obterCargos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargos'),
        backgroundColor: Color(0xFF008584),
      ),
      body: Center(
        child: FutureBuilder<List<Cargos>>(
          future: cargos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (!snapshot.hasData) {
              return Text('Nenhum dado disponível');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Cargos cargo = snapshot.data![index];
                  return ListTile(
                    title: Text(cargo.nome!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Coloque aqui a lógica para edição
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Coloque aqui a lógica para exclusão
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF008584),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CadastroCargo(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
