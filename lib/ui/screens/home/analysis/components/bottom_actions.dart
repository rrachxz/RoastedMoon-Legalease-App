import 'package:flutter/material.dart';

class DocBottomActions extends StatelessWidget {
  final VoidCallback onOpenChat;
  final void Function(String message) onQuickMessage;

  const DocBottomActions({
    super.key,
    required this.onOpenChat,
    required this.onQuickMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick action buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickButton(
                  label: 'Explain the Document to me like I\'m 5',
                  onTap: () =>
                      onQuickMessage('Explain the document to me like I\'m 5'),
                ),
                const SizedBox(width: 12),
                _buildQuickButton(
                  label: 'Explain the Document',
                  onTap: () =>
                      onQuickMessage('Explain this document in detail'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Ask anything bar
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF2196F3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 28),
                  onPressed: onOpenChat,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onOpenChat,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Text(
                      'Ask anything',
                      style: TextStyle(color: Colors.black38, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: Color(0xFF2196F3), width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF2196F3),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}