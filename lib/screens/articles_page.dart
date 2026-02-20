import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List _articles = [];
  bool _isLoading = true;
  String _searchQuery = "law OR scams OR cybersecurity OR rights"; // Default legal filter

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  // --- CONNECT TO API ---
  Future<void> _fetchArticles({String? customQuery}) async {
  setState(() => _isLoading = true);
  const apiKey = '010005c2b57b497f818cf4b0e11efdfc'; 

  // 1. Define your "Legal & Security" keywords
  // We use quotes " " for exact phrases like "cyber security"
  String legalKeywords = '(law OR legal OR "cyber security" OR scam OR "consumer rights")';

  // 2. Combine with user search if they typed something
  String finalQuery = customQuery != null 
      ? '$customQuery AND $legalKeywords' 
      : legalKeywords;

  // 3. Define trusted domains (optional, but makes results much better)
  String trustedDomains = 'reuters.com,apnews.com,theverge.com,wired.com,justice.gov';

  // 4. Build the URL with language=en and the tightened parameters
  final url = 'https://newsapi.org/v2/everything?'
      'q=${Uri.encodeComponent(finalQuery)}' // Tighten by keywords
      '&domains=$trustedDomains'            // Tighten by source
      '&language=en'                        // Filter for English
      '&sortBy=publishedAt'
      '&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _articles = json.decode(response.body)['articles'];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching news: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            // --- SAME ROUNDED SEARCH BAR AS CHAT ---
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                onSubmitted: (value) => _fetchArticles(customQuery: "$value AND (law OR scam OR rights)"),
                decoration: const InputDecoration(
                  hintText: "Search legal news...",
                  prefixIcon: Icon(Icons.search, color: Color(0xFF0086FF)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // --- ARTICLES LIST ---
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : ListView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (context, index) => _buildArticleCard(_articles[index]),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(dynamic article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // Blue border to match your Chat History style
        border: Border.all(color: const Color(0xFF0086FF).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to full article URL
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Larger margin for text
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category/Topic Tag
              const Text(
                "LEGAL UPDATE", 
                style: TextStyle(
                  color: Color(0xFF0086FF), 
                  fontWeight: FontWeight.bold, 
                  fontSize: 11,
                  letterSpacing: 1.1,
                )
              ),
              const SizedBox(height: 10),
              
              // Title: Bold and Blue as requested
              Text(
                article['title'] ?? 'No Title available',
                style: const TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black, // or Color(0xFF0086FF) if you want titles blue
                  height: 1.3,
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Footer: Author and Reading Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "By ${article['author'] ?? 'Legal Desk'}",
                      style: const TextStyle(
                        color: Color(0xFF0086FF), 
                        fontWeight: FontWeight.w600, 
                        fontSize: 13
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Text(
                    "4 min read", 
                    style: TextStyle(color: Colors.grey, fontSize: 12)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}