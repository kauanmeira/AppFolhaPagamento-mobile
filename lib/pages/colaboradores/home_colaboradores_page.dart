import 'dart:convert';
import 'package:app_folha_pagamento/models/Colaboradores.dart';
import 'package:app_folha_pagamento/models/Colaboradores.dart';
import 'package:app_folha_pagamento/pages/cargos/cadastro_cargo.dart';
import 'package:app_folha_pagamento/pages/colaboradores/cadastro_colaborador.dart';
import 'package:app_folha_pagamento/pages/colaboradores/detalhes_colaborador_page.dart';
import 'package:app_folha_pagamento/pages/colaboradores/editar_colaborador.dart';
import 'package:app_folha_pagamento/pages/home_page.dart';
import 'package:app_folha_pagamento/services/colaborador_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeColaboradoresPage extends StatefulWidget {
  const HomeColaboradoresPage({Key? key}) : super(key: key);

  @override
  State<HomeColaboradoresPage> createState() => _HomeColaboradoresPageState();
}

class _HomeColaboradoresPageState extends State<HomeColaboradoresPage> {
  late Future<List<Colaboradores>> colaboradores;
  final ColaboradorService colaboradorService = ColaboradorService();

  @override
  void initState() {
    super.initState();
    colaboradores = colaboradorService.obterColaboradores();
  }

  Future<void> recarregarDadosColaborador() async {
    setState(() {
      colaboradores = colaboradorService.obterColaboradores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colaboradores'),
        backgroundColor: Color(0xFF008584),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Colaboradores>>(
          future: colaboradores,
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
                  Colaboradores colaborador = snapshot.data![index];
                  return ListTile(
                    title: Text('${colaborador.nome} ${colaborador.sobrenome}'),
                    subtitle: Text(colaborador.cpf!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => EditarColaborador(
                                  colaboradorId: colaborador.id!,
                                  recarregarDadosColaborador:
                                      recarregarDadosColaborador,
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
                            // Coloque aqui a lógica para exclusão
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navegue para a tela de detalhes do colaborador
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalhesColaboradorPage(colaborador: colaborador),
                        ),
                      );
                    },
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
              builder: (context) => CadastroColaborador(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
