import 'package:flutter/material.dart';
import 'package:roastedmoon_legalease/data/scam_data.dart';
import 'package:roastedmoon_legalease/ui/screens/home/scam/components/scam_card.dart';
import 'package:roastedmoon_legalease/ui/screens/home/scam/components/scam_modal.dart';

class ScamAlertsPage extends StatefulWidget {
  const ScamAlertsPage({super.key});

  @override
  State<ScamAlertsPage> createState() => _ScamAlertsPageState();
}

class _ScamAlertsPageState extends State<ScamAlertsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> get _filteredScams {
    if (_searchQuery.isEmpty) return allScams;

    return allScams.where((scam) {
      final titleMatch = scam['title']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final categoryMatch = scam['category']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final descMatch = scam['description']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return titleMatch || categoryMatch || descMatch;
    }).toList();
  }

  void _showScamDetails(Map<String, dynamic> scam) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScamModal(scam: scam),
    );
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
            _buildSearchBar(),
            Expanded(child: _buildScamList()),
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
              'Scam Alerts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: 'Search scams...',
            hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.black38),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildScamList() {
    final scams = _filteredScams;

    if (scams.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 52, color: Colors.grey[200]),
            const SizedBox(height: 14),
            Text(
              'No scams found',
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
      itemCount: scams.length,
      itemBuilder: (context, index) => ScamCard(
        scam: scams[index],
        onTap: () => _showScamDetails(scams[index]),
      ),
    );
  }
}