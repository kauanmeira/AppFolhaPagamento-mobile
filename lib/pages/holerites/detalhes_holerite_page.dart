import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:app_folha_pagamento/models/Holerites.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/holerite_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';

class DetalhesHoleritePage extends StatelessWidget {
  final Holerites holerite;
  final UsuarioService usuarioService = UsuarioService();
  final HoleriteService holeriteService = HoleriteService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  DetalhesHoleritePage({
    Key? key,
    required this.holerite,
  }) : super(key: key);

  Future<void> _mostrarDialogReenvio(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reenviar Holerite?'),
          content: Text(
            'Deseja realmente reenviar o holerite para o email do colaborador ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reenviarHolerite();
              },
              child: Text('Reenviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    authMiddleware.checkAuthAndNavigate(context);
    final dateFormat = DateFormat('MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Folha de Pagamento',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF008584),
        actions: [
          IconButton(
            icon: Icon(Icons.email_outlined),
            onPressed: () => _mostrarDialogReenvio(context),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person,
                size: 80.0,
                color: Colors.blue,
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<String>(
                future: _obterNomeColaborador(holerite.colaboradorId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      'Erro ao obter nome do colaborador: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.red,
                      ),
                    );
                  } else {
                    final nomeColaborador =
                        snapshot.data ?? 'Nome do Colaborador Desconhecido';
                    return _buildInfoRow("Colaborador", nomeColaborador);
                  }
                },
              ),
              _buildInfoRow(
                "Período",
                dateFormat
                    .format(DateTime(holerite.ano ?? 0, holerite.mes ?? 1)),
              ),
              _buildInfoRow(
                "Salário Bruto",
                "R\$ ${holerite.salarioBruto!.toStringAsFixed(2)}",
              ),
              _buildInfoRow(
                "Desconto INSS",
                "R\$ ${holerite.descontoINSS!.toStringAsFixed(2)}",
              ),
              _buildInfoRow(
                "Desconto IRRF",
                "R\$ ${holerite.descontoIRRF!.toStringAsFixed(2)}",
              ),
              _buildInfoRow("Horas Normais", holerite.horasNormais.toString()),
              _buildInfoRow("Horas Extras", holerite.horasExtras.toString()),
              _buildInfoRow(
                "Salário Líquido",
                "R\$ ${holerite.salarioLiquido!.toStringAsFixed(2)}",
              ),
              _buildInfoRow(
                "Dependentes",
                holerite.dependentesHolerite.toString(),
              ),
              _buildInfoRow("Tipo", holerite.tipo.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Flexible(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _obterNomeColaborador(int colaboradorId) async {
    String? token = await usuarioService.getToken();
    return await holeriteService.obterNomeSobrenomeColaborador(
      colaboradorId,
      token!,
    );
  }

  void _reenviarHolerite() async {
    String? token = await usuarioService.getToken();
    if (token != null) {
      holeriteService.reenviarHolerite(holerite.id!, token);
    } else {
      print('Erro: Token do usuário não encontrado');
    }
  }
}
