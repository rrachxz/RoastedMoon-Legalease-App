import 'package:flutter/material.dart';
import 'package:roastedmoon_legalease/ui/screens/chat/components/chat_list.dart';
import 'package:roastedmoon_legalease/ui/screens/chat/components/chat_searchbar.dart';
import 'package:roastedmoon_legalease/data/chat_data.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, String>> get _filteredChats {
    if (_searchQuery.isEmpty) return allChats;
    return allChats
        .where(
          (chat) =>
              chat['title']!.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              chat['preview']!.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            ChatSearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            Expanded(
              child: ChatList(chats: _filteredChats, searchQuery: _searchQuery),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 25, 20, 12),
      child: Text(
        'Recent Chats',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
