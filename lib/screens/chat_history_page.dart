import 'package:flutter/material.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final List<Map<String, String>> _allChats = [
    {"title": "Employment Contract Review", "document": "my_job_contract.pdf", "time": "Feb 20"},
    {"title": "Apartment Lease Analysis", "document": "rental_v2.docx", "time": "Feb 18"},
    {"title": "NDA Explanation", "document": "startup_nda.pdf", "time": "Feb 15"},
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filter the list based on what the user types in the search bar
    final filteredChats = _allChats
        .where((chat) => chat['title']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Chat History",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // --- ROUNDED SEARCH BAR ---
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), // Light grey background
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search your chats...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF0086FF)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            
            const SizedBox(height: 25),

            // --- CHAT LIST ---
            Expanded(
              child: filteredChats.isEmpty
                  ? const Center(child: Text("No chats found", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: filteredChats.length,
                      itemBuilder: (context, index) {
                        final chat = filteredChats[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xFF0086FF).withOpacity(0.15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE3F2FD),
                              child: Icon(Icons.chat_bubble_outline, color: Color(0xFF0086FF), size: 20),
                            ),
                            title: Text(
                              chat['title']!,
                              style: const TextStyle(
                                color: Color(0xFF0086FF), // Blue text
                                fontWeight: FontWeight.bold, // Bold text
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "File: ${chat['document']}",
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ),
                            trailing: Text(
                              chat['time']!,
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            onTap: () {
                              // Connect to Chat View logic here
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}