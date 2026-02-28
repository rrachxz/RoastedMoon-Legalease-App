import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:roastedmoon_legalease/ui/screens/components/doc_validity.dart';
import 'package:roastedmoon_legalease/ui/screens/components/doc_points_section.dart';
import 'package:roastedmoon_legalease/ui/screens/home/analysis/components/header_card.dart';
import 'package:roastedmoon_legalease/ui/screens/home/analysis/components/loading_view.dart';
import 'package:roastedmoon_legalease/ui/screens/home/analysis/components/bottom_actions.dart';
import 'package:roastedmoon_legalease/ui/screens/home/analysis/components/chat_modal.dart';
import 'package:roastedmoon_legalease/services/gemini/doc_analysis.dart';

class DocumentAnalysisPage extends StatefulWidget {
  final String fileName;
  final int fileSize;
  final String? filePath;
  final Uint8List? fileBytes;
  final Map<String, dynamic>? preloadedAnalysis;


  const DocumentAnalysisPage({
    super.key,
    required this.fileName,
    required this.fileSize,
    this.filePath,
    this.fileBytes,
    this.preloadedAnalysis,
  });

  @override
  State<DocumentAnalysisPage> createState() => _DocumentAnalysisPageState();
}

class _DocumentAnalysisPageState extends State<DocumentAnalysisPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isAnalyzing = true;

  String _validity = 'valid';
  String _validityMessage = 'Document is Valid';
  List<String> _keyPoints = [];
  List<String> _importantNotices = [];
  final List<Map<String, String>> _chatMessages = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _analyzeDocument();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _analyzeDocument() async {
    try {
      if (widget.preloadedAnalysis != null) {
        if (mounted) {
          setState(() {
            final result = widget.preloadedAnalysis!;
            _validity = result['validity'] ?? 'valid';
            _validityMessage = result['validityMessage'] ?? 'Document is Valid';
            _keyPoints = List<String>.from(result['keyPoints'] ?? []);
            _importantNotices = List<String>.from(
              result['importantNotices'] ?? [],
            );
            _isAnalyzing = false;
          });
        }
        return;
      }
      final result = await DocAnalysisService.analyzeDocument(
        widget.filePath ?? '',
        widget.fileName,
        widget.fileBytes,
      );

      if (mounted) {
        setState(() {
          _validity = result['validity'] ?? 'valid';
          _validityMessage = result['validityMessage'] ?? 'Document is Valid';
          _keyPoints = List<String>.from(result['keyPoints'] ?? []);
          _importantNotices = List<String>.from(
            result['importantNotices'] ?? [],
          );
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _keyPoints = ['Error analyzing document. Please try again.'];
          _importantNotices = ['Unable to generate notices at this time.'];
        });
      }
    }
  }

  void _openChatView({String? prefilledMessage}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChatModal(
        fileName: widget.fileName,
        keyPoints: _keyPoints,
        importantNotices: _importantNotices,
        chatMessages: _chatMessages,
        prefilledMessage: prefilledMessage,
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
            Expanded(
              child: _isAnalyzing ? _buildLoadingView() : _buildResultsView(),
            ),
            if (!_isAnalyzing)
              DocBottomActions(
                onOpenChat: _openChatView,
                onQuickMessage: (msg) => _openChatView(prefilledMessage: msg),
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
              'Document Analysis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return DocLoadingView(
      animationController: _animationController,
      fileName: widget.fileName,
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DocAnalysisHeaderCard(fileName: widget.fileName),
          const SizedBox(height: 16),
          DocValidityStatus(
            validity: _validity,
            validityMessage: _validityMessage,
          ),
          const SizedBox(height: 24),
          DocPointsSection(
            title: 'Key Points',
            headerColor: const Color(0xFF2196F3),
            points: _keyPoints,
            emptyMessage: 'No key points found',
          ),
          const SizedBox(height: 24),
          DocPointsSection(
            title: 'Important Notices',
            headerColor: Colors.orange,
            points: _importantNotices,
            emptyMessage: 'No important notices found',
          ),
        ],
      ),
    );
  }
}