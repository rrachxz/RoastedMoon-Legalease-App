import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roastedmoon_legalease/data/legal_terms.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // 4 main screens from Figma
  static final List<Widget> _pages = [
    const HomeScreenContent(), 
    const Center(child: Text('Chat Page', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Articles Page', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Profile Page', style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  // --- SAVE TO HISTORY ---
  Future<void> _saveToHistory(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    // Get existing list or empty list if it doesn't exist
    List<String> history = prefs.getStringList('upload_history') ?? [];
    history.insert(0, fileName); // Add new file at the top
    await prefs.setStringList('upload_history', history);
  }

  // --- UPLOAD DOCUMENT ---
  Future<void> _pickDocument(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx','txt'],
    );

    if (result != null) {
      String fileName = result.files.first.name;
      await _saveToHistory(fileName); // Save it!
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Uploaded: $fileName (Saved to History)")),
        );
      }
    }
  }

  // --- SCAN WITH CAMERA ---
  Future<void> _scanWithCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _saveToHistory("Scan_${DateTime.now().millisecond}.jpg");

      // CALL AI CHAT FUNCTION HERE

      print("Document Scanned: ${image.path}");
    }
  }

  // --- SCAM ALERTS (Maps Search) ---
  Future<void> _contactLawCenter() async {
    // This searches Google Maps for "Legal Aid" near the user
    final Uri url = Uri.parse('https://www.google.com/maps/search/legal+aid+office/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch maps');
    }
  }

  final String userName = "Bulan Gosong";
  @override
  Widget build(BuildContext context) {
    // Use SafeArea directly, NO Scaffold here
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Dynamic Name)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Welcome,", style: TextStyle(color: Colors.grey)),
                    Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                CircleAvatar(backgroundColor: Colors.blueGrey, radius: 24, child: Icon(Icons.person, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Upload Card
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () => _pickDocument(context),
                    contentPadding: const EdgeInsets.symmetric(vertical: 25),
                    title: const Icon(Icons.cloud_upload_outlined, size: 45, color: Colors.white),
                    subtitle: const Text("Upload Document", 
                      textAlign: TextAlign.center, 
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                  ),
                  const Divider(color: Colors.white24, height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton.icon(
                      onPressed: _scanWithCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Scan with Camera"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 35),

            // 3. Quick Actions Grid
            const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildActionCard("My Documents", Icons.description, () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
                }),
                _buildActionCard("Jargon Decoder", Icons.search, () {
                  showSearch(context: context, delegate: JargonSearchDelegate());
                }),
                _buildActionCard("Legal Aid", Icons.gavel, _contactLawCenter),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: 32),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 13, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class JargonSearchDelegate extends SearchDelegate {

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E1E1E)),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white), // The text you type
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear, color: Colors.blue), onPressed: () => query = '')
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.blue),
        onPressed: () => close(context, null),
      );

  // 2. THIS IS THE "DECODER" RESULT SCREEN
  @override
  Widget buildResults(BuildContext context) {
    final definition = legalDictionary[query] ?? "Definition not found.";
    
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(query, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 15),
          const Divider(color: Colors.grey),
          const SizedBox(height: 15),
          Text(definition, style: const TextStyle(fontSize: 18, color: Colors.white, height: 1.5)),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Filter keys from the dictionary
    final suggestions = legalDictionary.keys
        .where((term) => term.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: const Color(0xFF1E1E1E),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(suggestions[i], style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
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
    setState(() {
      _history = prefs.getStringList('upload_history') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Documents"), backgroundColor: const Color(0xFF1E1E1E)),
      backgroundColor: const Color(0xFF1E1E1E),
      body: _history.isEmpty
          ? const Center(child: Text("No documents yet", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
                title: Text(_history[index], style: const TextStyle(color: Colors.white)),
                subtitle: const Text("Tap to view", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),
    );
  }
}
