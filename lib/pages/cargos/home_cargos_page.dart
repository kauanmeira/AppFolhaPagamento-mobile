import 'package:app_folha_pagamento/pages/cargos/editar_cargo.dart';
import 'package:flutter/material.dart';
import 'package:app_folha_pagamento/models/Cargos.dart';
import 'package:app_folha_pagamento/pages/cargos/cadastro_cargo.dart';
import 'package:app_folha_pagamento/services/cargo_service.dart';

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
    recarregarDadosCargos();
  }

  Future<void> recarregarDadosCargos() async {
    setState(() {
      cargos = cargoService.obterCargos();
    });
  }

  Future<void> _confirmarExclusao(Cargos cargo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja realmente excluir este cargo?'),
          content: Text('Cargo: ${cargo.nome}'),
          actions: <Widget>[
            TextButton(
              child: Text('Sim'),
              onPressed: () async {
                try {
                  String? mensagem = await cargoService.excluirCargo(cargo.id!);
                  if (mensagem != null) {
                    // Exibe a mensagem de sucesso
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mensagem),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Fecha o diálogo
                    Navigator.of(context).pop();

                    // Recarrega os dados após a exclusão
                    recarregarDadosCargos();
                  }
                } catch (error) {
                  // Lida com erros ao excluir
                  print('Erro ao excluir cargo: $error');
                  // Exibe uma mensagem de erro se necessário
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir cargo: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
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
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => EditarCargo(
                                  cargoId: cargo.id!,
                                  recarregarDadosCargos: recarregarDadosCargos,
                                ),
                              ),
                            )
                                .then((value) {
                              // Após a edição, os dados serão recarregados automaticamente
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmarExclusao(
                                cargo); // Chame a função de confirmação
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
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => CadastroCargo(),
            ),
          )
              .then((value) {
            recarregarDadosCargos();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
