import 'package:flutter/material.dart';

Color getSeverityColor(String severity) {
  switch (severity) {
    case 'critical':
      return Colors.red;
    case 'high':
      return Colors.orange;
    case 'medium':
      return Colors.amber;
    case 'low':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

IconData getSeverityIcon(String severity) {
  switch (severity) {
    case 'critical':
      return Icons.dangerous;
    case 'high':
      return Icons.warning;
    case 'medium':
      return Icons.error_outline;
    case 'low':
      return Icons.info_outline;
    default:
      return Icons.help_outline;
  }
}