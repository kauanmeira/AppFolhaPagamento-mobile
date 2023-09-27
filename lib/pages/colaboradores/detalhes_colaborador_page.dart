import 'package:app_folha_pagamento/models/Colaboradores.dart';
import 'package:flutter/material.dart';

class DetalhesColaboradorPage extends StatelessWidget {
  final Colaboradores colaborador;

  DetalhesColaboradorPage({required this.colaborador});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${colaborador.nome} ${colaborador.sobrenome}',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Color(0xFF008584),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow("Nome Completo",
                  "${colaborador.nome} ${colaborador.sobrenome}"),
              _buildInfoRow("CPF", colaborador.cpf!),
              _buildInfoRow("Salário Base",
                  "R\$ ${colaborador.salarioBase!.toStringAsFixed(2)}"),
              _buildInfoRow("Data de Nascimento", colaborador.dataNascimento!),
              _buildInfoRow("Data de Admissão", colaborador.dataAdmissao!),
              _buildInfoRow("Dependentes", colaborador.dependentes.toString()),
              _buildInfoRow("Filhos", colaborador.filhos.toString()),
              _buildInfoRow("Cargo ID", colaborador.cargoId.toString()),
              _buildInfoRow("Empresa ID", colaborador.empresaId.toString()),
              _buildInfoRow("CEP", colaborador.cep!),
              _buildInfoRow("Logradouro", colaborador.logradouro!),
              _buildInfoRow("Número", colaborador.numero.toString()),
              _buildInfoRow("Bairro", colaborador.bairro!),
              _buildInfoRow("Cidade", colaborador.cidade!),
              _buildInfoRow("Estado", colaborador.estado!),
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
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(width: 16.0), // Espaço entre os campos
          Flexible(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
