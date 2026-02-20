import 'package:flutter/material.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  // This list is what your friend's AI logic will eventually populate
  final List<Map<String, String>> _allChats = [
    {"title": "Employment Contract Review", "document": "my_job_contract.pdf", "time": "Feb 20"},
    {"title": "Apartment Lease Analysis", "document": "rental_v2.docx", "time": "Feb 18"},
    {"title": "NDA Explanation", "document": "startup_nda.pdf", "time": "Feb 15"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Chat History", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blue),
            onPressed: () {
              // This connects to the search logic
              showSearch(context: context, delegate: ChatSearchDelegate(_allChats));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Your requested margin
        child: ListView.builder(
          itemCount: _allChats.length,
          itemBuilder: (context, index) {
            final chat = _allChats[index];
            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF2196F3),
                  child: Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                ),
                title: Text(
                  chat['title']!, // The AI summary title
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "File: ${chat['document']}", // The uploaded filename
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: Text(chat['time']!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                onTap: () {
                  // Connects to your friend's ChatBox screen
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Search Logic to find previous chats
class ChatSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> chats;
  ChatSearchDelegate(this.chats);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null)
  );

  @override
  Widget buildResults(BuildContext context) => Container(); // Implement if needed

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = chats.where((c) => c['title']!.toLowerCase().contains(query.toLowerCase())).toList();
    return Container(
      color: const Color(0xFF1E1E1E),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(results[i]['title']!, style: const TextStyle(color: Colors.white)),
          subtitle: Text(results[i]['document']!, style: const TextStyle(color: Colors.grey)),
          onTap: () => close(context, null),
        ),
      ),
    );
  }
}