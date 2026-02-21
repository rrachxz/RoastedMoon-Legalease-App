import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roastedmoon_legalease/data/legal_terms.dart';
import 'dart:developer' as developer;


class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  Future<void> _saveToHistory(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('upload_history') ?? [];
    history.insert(0, fileName);
    await prefs.setStringList('upload_history', history);
  }

  Future<void> _pickDocument(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      String fileName = result.files.first.name;
      await _saveToHistory(fileName);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Uploaded: $fileName")),
        );
      }
    }
  }

  Future<void> _scanWithCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _saveToHistory("Scan_${DateTime.now().millisecond}.jpg");
      // FIX: print() replaced with developer.log() — safe for production
      developer.log("Document Scanned: ${image.path}", name: 'HomeScreenContent');
    }
  }

  Future<void> _contactLawCenter() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/legal+aid+office/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch maps');
    }
  }

  final String userName = "Bulan Gosong";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Welcome,", style: TextStyle(color: Colors.grey)),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  backgroundColor: Color(0xFFD9D9D9),
                  radius: 24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Upload Card
            GestureDetector(
              onTap: () => _pickDocument(context),
              child: Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0086FF), Color(0xFF5AB2FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file, color: Colors.white, size: 35),
                    SizedBox(height: 8),
                    Text(
                      "Upload Document",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 3. Scan with Camera Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _scanWithCamera,
                icon: const Icon(Icons.camera_alt_outlined, size: 20),
                label: const Text("Scan with Camera"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0086FF),
                  side: const BorderSide(color: Color(0xFFD9D9D9)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 35),

            // 4. Quick Actions Grid
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildActionCard(
                  context,
                  "My Documents",
                  Icons.description,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  ),
                ),
                _buildActionCard(
                  context,
                  "Jargon Decoder",
                  Icons.search,
                  () => showSearch(
                    context: context,
                    delegate: JargonSearchDelegate(),
                  ),
                ),
                _buildActionCard(
                  context,
                  "Legal Aid",
                  Icons.gavel,
                  _contactLawCenter,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 32),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JargonSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.blue),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.blue),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final definition = legalDictionary[query] ?? "Definition not found.";
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            query,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 15),
          Text(
            definition,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = legalDictionary.keys
        .where((term) => term.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(suggestions[i],
              style: const TextStyle(color: Colors.black)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () {
            query = suggestions[i];
            showResults(context);
          },
        ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _history = prefs.getStringList('upload_history') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Documents")),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                "No documents yet",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
                title: Text(
                  _history[index],
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: const Text(
                  "Tap to view",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
    );
  }
}