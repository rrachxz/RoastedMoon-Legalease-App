import 'package:flutter/material.dart';

class ChatDateLabel extends StatelessWidget {
  final String label;

  const ChatDateLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey[400],
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}