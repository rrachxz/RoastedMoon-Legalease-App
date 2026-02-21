import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List _articles = [];
  bool _isLoading = true;
  bool _hasError = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchArticles({String? customQuery}) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    const apiKey = '010005c2b57b497f818cf4b0e11efdfc';

    String legalKeywords = '(law OR legal OR "cyber security" OR scam OR "consumer rights")';
    String finalQuery = customQuery != null
        ? '$customQuery AND $legalKeywords'
        : legalKeywords;

    String trustedDomains = 'reuters.com,apnews.com,theverge.com,wired.com,justice.gov';

    final url = 'https://newsapi.org/v2/everything?'
        'q=${Uri.encodeComponent(finalQuery)}'
        '&domains=$trustedDomains'
        '&language=en'
        '&sortBy=publishedAt'
        '&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          _articles = json.decode(response.body)['articles'];
          _isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      developer.log("Error fetching news: $e", name: 'ArticlesPage');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Articles",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEARCH BAR ---
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _fetchArticles(customQuery: value.trim());
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search legal news...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0086FF)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _fetchArticles();
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            // --- SECTION LABEL ---
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 14),
              child: Text(
                "Latest Legal News",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            // --- ARTICLES LIST ---
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF0086FF)),
                    )
                  : _hasError
                      ? _buildErrorState()
                      : _articles.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: _articles.length,
                              itemBuilder: (context, index) =>
                                  _buildArticleCard(_articles[index]),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(dynamic article) {
    final String title = article['title'] ?? 'No title available';
    final String author = article['author'] ?? 'Legal Desk';
    final String? imageUrl = article['urlToImage'];
    final String source = article['source']?['name'] ?? 'Unknown Source';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0086FF).withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to full article URL
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ARTICLE IMAGE (if available) ---
            if (imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SOURCE TAG ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0086FF).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      source.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF0086FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- TITLE ---
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),

                  // --- FOOTER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline,
                                size: 14, color: Color(0xFF0086FF)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                author,
                                style: const TextStyle(
                                  color: Color(0xFF0086FF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.access_time, size: 13, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            "4 min read",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No articles found",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try a different search term",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "Couldn't load articles",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchArticles,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0086FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text("Retry", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}