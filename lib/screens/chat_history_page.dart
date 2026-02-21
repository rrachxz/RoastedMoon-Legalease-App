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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

            // --- SEARCH BAR ---
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search your chats...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0086FF)),
                  // FIX: show clear button only when there's text
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () => setState(() {
                            _searchController.clear();
                            _searchQuery = "";
                          }),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- CHAT LIST ---
            Expanded(
              child: filteredChats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline,
                              size: 52, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          const Text(
                            "No chats found",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredChats.length,
                      itemBuilder: (context, index) {
                        final chat = filteredChats[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            // FIX: withOpacity() deprecated → withValues(alpha:)
                            border: Border.all(
                              color: const Color(0xFF0086FF).withValues(alpha: 0.15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE3F2FD),
                              child: Icon(Icons.chat_bubble_outline,
                                  color: Color(0xFF0086FF), size: 20),
                            ),
                            title: Text(
                              chat['title']!,
                              style: const TextStyle(
                                color: Color(0xFF0086FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "File: ${chat['document']}",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                            ),
                            trailing: Text(
                              chat['time']!,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 11),
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