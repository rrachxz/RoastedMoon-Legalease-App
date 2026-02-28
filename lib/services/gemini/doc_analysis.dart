import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class DocAnalysisService {
  static const String _apiKey = 'AIzaSyB0XLXYxmfJ2FSI6Jpebp7dZqm6E3ocZ-g';

  static Future<Map<String, dynamic>> analyzeDocument(
    String filePath,
    String fileName,
    Uint8List? fileBytes,
  ) async {
    try {
      final model = GenerativeModel(
        model: 'models/gemini-flash-lite-latest',
        apiKey: _apiKey,
      );

      Uint8List? documentBytes = await _getDocumentBytes(fileBytes, filePath);

      final prompt = _buildAnalysisPrompt(fileName);

      final parts = <Part>[TextPart(prompt)];
      if (documentBytes != null && documentBytes.isNotEmpty) {
        parts.add(DataPart('application/pdf', documentBytes));
      }

      final content = [Content.multi(parts)];
      final response = await model.generateContent(content);
      final text = response.text ?? '';

      if (text.isEmpty) {
        throw Exception('Empty response from AI');
      }

      return _parseResponse(text);
    } catch (e) {
      return _buildErrorResponse(e, fileBytes);
    }
  }

  static Future<Uint8List?> _getDocumentBytes(
    Uint8List? providedBytes,
    String filePath,
  ) async {
    if (providedBytes != null) {
      return providedBytes;
    }

    if (filePath.isNotEmpty) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          return await file.readAsBytes();
        }
      } catch (_) {}
    }

    return null;
  }

  static String _buildAnalysisPrompt(String fileName) {
    return '''You are a professional legal document analyzer.

Analyze the document "$fileName" and provide a comprehensive legal analysis.

Return ONLY valid JSON with this exact structure (no markdown formatting):
{
  "validity": "valid",
  "validityMessage": "Brief professional assessment",
  "keyPoints": [
    "First key legal point or clause",
    "Second important term",
    "Third critical information"
  ],
  "importantNotices": [
    "First warning or deadline",
    "Second legal obligation or risk"
  ]
}

Requirements:
- Be specific and professional
- Focus on legal aspects
- Identify potential risks or obligations
- Highlight important deadlines or terms''';
  }

  static Map<String, dynamic> _parseResponse(String response) {
    String jsonText = response.trim();

    if (jsonText.contains('```json')) {
      jsonText = jsonText.split('```json')[1].split('```')[0].trim();
    } else if (jsonText.contains('```')) {
      jsonText = jsonText.split('```')[1].split('```')[0].trim();
    }

    return json.decode(jsonText) as Map<String, dynamic>;
  }

  static Map<String, dynamic> _buildErrorResponse(
    Object error,
    Uint8List? fileBytes,
  ) {
    final errorMessage = error.toString();
    final truncatedError = errorMessage.length > 80
        ? '${errorMessage.substring(0, 80)}...'
        : errorMessage;

    return {
      'validity': 'needs_review',
      'validityMessage': 'Analysis Error',
      'keyPoints': [
        'Unable to analyze document',
        'Error: $truncatedError',
        fileBytes == null
            ? 'No file data provided'
            : 'File data available (${fileBytes.length} bytes)',
      ],
      'importantNotices': [
        'Check your internet connection',
        'Ensure the document is in PDF format',
      ],
    };
  }
}