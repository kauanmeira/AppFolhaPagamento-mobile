import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF008584)),
          ),
          SizedBox(height: 8),
          Text(
            'Carregando...',
            style: TextStyle(color: Color(0xFF008584)),
          ),
        ],
      ),
    );
  }
}