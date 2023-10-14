import 'package:app_folha_pagamento/models/Holerites.dart';
import 'package:app_folha_pagamento/services/auth_middleware.dart';
import 'package:app_folha_pagamento/services/holerite_service.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalhesHoleritePage extends StatelessWidget {
  final Holerites holerite;
  final UsuarioService usuarioService = UsuarioService();
  final HoleriteService holeriteService = HoleriteService();
  final AuthMiddleware authMiddleware = AuthMiddleware();

  DetalhesHoleritePage({required this.holerite});

  @override
  Widget build(BuildContext context) {
    authMiddleware.checkAuthAndNavigate(context);
    final dateFormat = DateFormat('MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Holerite',
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Color(0xFF008584),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF008584), Color(0xFF005050)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                // Use um FutureBuilder para buscar o nome do colaborador
                future: _obterNomeColaborador(holerite.colaboradorId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      'Erro ao obter nome do colaborador: ${snapshot.error}',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
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
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 16.0), // Espaço entre os campos
          Flexible(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
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
        colaboradorId, token!);
  }
}