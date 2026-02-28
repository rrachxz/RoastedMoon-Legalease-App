import 'package:flutter/material.dart';
import 'package:roastedmoon_legalease/ui/screens/home/decoder/components/searchbar.dart';
import 'package:roastedmoon_legalease/ui/screens/home/decoder/components/terms_list.dart';
import 'package:roastedmoon_legalease/data/legalterms_data.dart';

class JargonDecoderPage extends StatefulWidget {
  const JargonDecoderPage({super.key});

  @override
  State<JargonDecoderPage> createState() => _JargonDecoderPageState();
}

class _JargonDecoderPageState extends State<JargonDecoderPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<MapEntry<String, String>> get _filteredTerms {
    if (_searchQuery.isEmpty) return legalTerms.entries.toList();

    return legalTerms.entries
        .where(
          (entry) =>
      entry.key.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.value.toLowerCase().contains(_searchQuery.toLowerCase()),
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
          children: [
            _buildHeader(),
            DecoderSearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            Expanded(
              child: TermsList(terms: _filteredTerms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Jargon Decoder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}