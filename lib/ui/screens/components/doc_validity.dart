import 'package:flutter/material.dart';

class DocValidityStatus extends StatelessWidget {
  final String validity;
  final String validityMessage;

  const DocValidityStatus({
    super.key,
    required this.validity,
    required this.validityMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = validity == 'valid';
    final color = isValid ? Colors.green : Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color[50],
        border: Border.all(color: color[300]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.warning,
            color: color[700],
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Validity Status: $validityMessage',
              style: TextStyle(
                color: color[700],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}