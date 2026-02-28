import 'package:flutter/material.dart';
import 'package:roastedmoon_legalease/ui/screens/chat/components/chat_date_label.dart';
import 'package:roastedmoon_legalease/ui/screens/chat/components/chat_tile.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, String>> chats;
  final String searchQuery;

  const ChatList({
    super.key,
    required this.chats,
    required this.searchQuery,
  });

  Map<String, List<Map<String, String>>> get _groupedChats {
    final Map<String, List<Map<String, String>>> grouped = {};
    for (final chat in chats) {
      final date = chat['date']!;
      grouped.putIfAbsent(date, () => []).add(chat);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
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

    if (searchQuery.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final isLast = index == chats.length - 1;
          return ChatTile(
            chat: chats[index],
            showDivider: !isLast,
          );
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
            ChatDateLabel(label: date),
            ...sectionChats.asMap().entries.map((entry) {
              final isLast = entry.key == sectionChats.length - 1;
              return ChatTile(
                chat: entry.value,
                showDivider: !isLast,
              );
            }),
          ],
        );
      },
    );
  }
}