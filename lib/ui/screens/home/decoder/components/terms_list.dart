import 'package:flutter/material.dart';
import 'package:roastedmoon_legalease/ui/screens/home/decoder/components/terms_card.dart';

class TermsList extends StatelessWidget {
  final List<MapEntry<String, String>> terms;

  const TermsList({super.key, required this.terms});

  @override
  Widget build(BuildContext context) {
    if (terms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 52, color: Colors.grey[200]),
            const SizedBox(height: 14),
            Text(
              'No terms found',
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

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: terms.length,
      itemBuilder: (context, index) {
        final term = terms[index];
        return TermCard(
          term: term.key,
          definition: term.value,
        );
      },
    );
  }
}