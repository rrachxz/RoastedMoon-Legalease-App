import 'package:flutter/material.dart';

class DocAnalysisHeaderCard extends StatelessWidget {
  final String fileName;

  const DocAnalysisHeaderCard({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        fileName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}