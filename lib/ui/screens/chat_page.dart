import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allChats = [
    {
      'title': 'Lease Agreement Review',
      'preview': 'Key clauses found regarding early termination...',
      'time': '2:45 PM',
      'date': 'Today',
    },
    {
      'title': 'Employment Contract',
      'preview': 'Non-compete clause identified. Notice period is 30 days.',
      'time': '11:20 AM',
      'date': 'Today',
    },
    {
      'title': 'Insurance Policy',
      'preview': 'Coverage limit is \$500,000. Exclusions include...',
      'time': 'Yesterday',
      'date': 'Yesterday',
    },
    {
      'title': 'NDA Analysis',
      'preview': 'Confidentiality period is 2 years. Both parties are bound...',
      'time': 'Mon',
      'date': 'Monday',
    },
    {
      'title': 'Partnership Agreement',
      'preview': 'Profit sharing ratio set to 60/40 as per clause 7.',
      'time': 'Sun',
      'date': 'Sunday',
    },
  ];

  List<Map<String, String>> get _filteredChats {
    if (_searchQuery.isEmpty) return _allChats;
    return _allChats
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

  //chat by date
  Map<String, List<Map<String, String>>> get _groupedChats {
    final Map<String, List<Map<String, String>>> grouped = {};
    for (final chat in _filteredChats) {
      final date = chat['date']!;
      grouped.putIfAbsent(date, () => []).add(chat);
    }
    return grouped;
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
            _buildSearchBar(),
            Expanded(child: _buildChatList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent Chats',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  //searchbar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: 'Search chats',
            hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.black38),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    final chats = _filteredChats;

    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 52,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 14),
            Text(
              'No chats found',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchQuery.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final isLast = index == chats.length - 1;
          return _buildChatTile(chats[index], showDivider: !isLast);
        },
      );
    }

    final grouped = _groupedChats;
    final dateKeys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: dateKeys.length,
      itemBuilder: (context, sectionIndex) {
        final date = dateKeys[sectionIndex];
        final sectionChats = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateLabel(date),
            ...sectionChats.asMap().entries.map((entry) {
              final isLast = entry.key == sectionChats.length - 1;
              return _buildChatTile(entry.value, showDivider: !isLast);
            }),
          ],
        );
      },
    );
  }

  Widget _buildDateLabel(String label) {
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

  Widget _buildChatTile(Map<String, String> chat, {bool showDivider = true}) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to DocumentAnalysisPage
      },
      splashColor: const Color(0xFF2196F3).withOpacity(0.06),
      highlightColor: const Color(0xFF2196F3).withOpacity(0.03),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            //doc icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2196F3), width: 1),
              ),
              child: const Icon(
                Icons.description_rounded,
                color: Color(0xFF2196F3),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            //title and preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat['title']!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            letterSpacing: -0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        chat['time']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    chat['preview']!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
