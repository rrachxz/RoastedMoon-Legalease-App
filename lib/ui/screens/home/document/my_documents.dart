import 'package:flutter/material.dart';
import 'package:roastedmoon_legalease/models/documents.dart';
import 'package:roastedmoon_legalease/services/firestore/firestore.dart';
import 'package:roastedmoon_legalease/ui/screens/home/analysis/doc_analysis_page.dart';

class MyDocumentsPage extends StatefulWidget {
  const MyDocumentsPage({super.key});

  @override
  State<MyDocumentsPage> createState() => _MyDocumentsPageState();
}

class _MyDocumentsPageState extends State<MyDocumentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, List<DocumentModel>> _groupByDate(List<DocumentModel> docs) {
    final Map<String, List<DocumentModel>> grouped = {};

    for (final doc in docs) {
      final date = doc.formattedDate;
      grouped.putIfAbsent(date, () => []).add(doc);
    }

    return grouped;
  }

  Future<void> _confirmDelete(DocumentModel doc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Delete "${doc.fileName}"?\n\nThis cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirestoreService.deleteDocument(doc.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Document deleted'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _viewDocument(DocumentModel doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentAnalysisPage(
          fileName: doc.fileName,
          fileSize: doc.fileSize,
          preloadedAnalysis: {
            'validity': doc.validity,
            'validityMessage': doc.validityMessage,
            'keyPoints': doc.keyPoints,
            'importantNotices': doc.importantNotices,
          },
        ),
      ),
    );
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
            Expanded(child: _buildDocumentList()),
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
              'My Documents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<int>(
            future: FirestoreService.getDocumentCount(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data! > 0) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${snapshot.data}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: 'Search documents...',
            hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.black38),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
    return StreamBuilder<List<DocumentModel>>(
      stream: _searchQuery.isEmpty
          ? FirestoreService.getDocuments()
          : FirestoreService.searchDocuments(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2196F3)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error loading documents',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final documents = snapshot.data ?? [];
        if (documents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _searchQuery.isEmpty
                      ? Icons.description_outlined
                      : Icons.search_off,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isEmpty
                      ? 'No documents yet'
                      : 'No documents found',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_searchQuery.isEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Upload your first document to get started',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ],
            ),
          );
        }

        if (_searchQuery.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return _buildDocumentTile(documents[index]);
            },
          );
        } else {
          final grouped = _groupByDate(documents);
          final dateKeys = grouped.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: dateKeys.length,
            itemBuilder: (context, sectionIndex) {
              final date = dateKeys[sectionIndex];
              final sectionDocs = grouped[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateLabel(date),
                  ...sectionDocs.map((doc) => _buildDocumentTile(doc)),
                ],
              );
            },
          );
        }
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

  Widget _buildDocumentTile(DocumentModel doc) {
    final isValid = doc.validity == 'valid';
    final statusColor = isValid ? Colors.green : Colors.orange;

    return Dismissible(
      key: Key(doc.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        await _confirmDelete(doc);
        return false;
      },
      child: InkWell(
        onTap: () => _viewDocument(doc),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            doc.fileName,
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
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          doc.readableFileSize,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(' • ', style: TextStyle(color: Colors.grey[400])),
                        Text(
                          doc.formattedTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(' • ', style: TextStyle(color: Colors.grey[400])),
                        Expanded(
                          child: Text(
                            '${doc.keyPoints.length} points',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}