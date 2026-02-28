import 'package:flutter/material.dart';

class DocLoadingView extends StatelessWidget {
  final AnimationController animationController;
  final String fileName;

  const DocLoadingView({
    super.key,
    required this.animationController,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Analyzing Document...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            fileName,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          const Text(
            'AI is reading your document',
            style: TextStyle(fontSize: 14, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}