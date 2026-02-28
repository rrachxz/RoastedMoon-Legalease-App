import 'package:flutter/material.dart';
import 'package:roastedmoon_legalease/ui/screens/components/chat_bubble.dart';
import 'package:roastedmoon_legalease/ui/screens/components/typing_indicator.dart';
import 'package:roastedmoon_legalease/services/gemini/ai_chat.dart';

class ChatModal extends StatefulWidget {
  final String fileName;
  final List<String> keyPoints;
  final List<String> importantNotices;
  final List<Map<String, String>> chatMessages;
  final String? prefilledMessage;

  const ChatModal({
    super.key,
    required this.fileName,
    required this.keyPoints,
    required this.importantNotices,
    required this.chatMessages,
    this.prefilledMessage,
  });

  @override
  State<ChatModal> createState() => _ChatModalState();
}

class _ChatModalState extends State<ChatModal> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<Map<String, String>> _messages;
  bool _isChatLoading = false;
  bool _autoSentPrefill = false;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.chatMessages);

    if (widget.prefilledMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_autoSentPrefill) {
          _autoSentPrefill = true;
          _sendMessage(widget.prefilledMessage!);
        }
      });
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isChatLoading = true;
    });

    _chatController.clear();
    _scrollToBottom();

    try {
      final aiResponse = await AiChatService.chatWithDocument(
        widget.fileName,
        message,
        widget.keyPoints,
        widget.importantNotices,
      );

      if (mounted) {
        setState(() {
          _messages.add({'role': 'assistant', 'content': aiResponse});
          _isChatLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content':
            'Sorry, I encountered an error. Please try asking another question.',
          });
          _isChatLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF2196F3),
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Chat with AI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ask me anything about this document',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + (_isChatLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const TypingIndicator();
                }
                final message = _messages[index];
                return ChatBubble(
                  message: message['content']!,
                  isUser: message['role'] == 'user',
                );
              },
            ),
          ),

          // Input bar
          Container(
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
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: TextField(
                      controller: _chatController,
                      decoration: const InputDecoration(
                        hintText: 'Ask about this document...',
                        hintStyle: TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2196F3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => _sendMessage(_chatController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}