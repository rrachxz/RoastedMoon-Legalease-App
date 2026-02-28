import 'package:google_generative_ai/google_generative_ai.dart';

class AiChatService {
  static const String _apiKey = 'AIzaSyB0XLXYxmfJ2FSI6Jpebp7dZqm6E3ocZ-g';

  static Future<String> chatWithDocument(
    String fileName,
    String userQuestion,
    List<String> keyPoints,
    List<String> importantNotices,
  ) async {
    try {
      final model = GenerativeModel(
        model: 'models/gemini-flash-lite-latest',
        apiKey: _apiKey,
      );

      final prompt =
          '''You are a helpful legal document assistant chatting with a user about their document "$fileName".

Document Context:
Key Points:
${keyPoints.map((point) => '- $point').join('\n')}

Important Notices:
${importantNotices.map((notice) => '- $notice').join('\n')}

User Question: $userQuestion

Instructions:
- Answer in a friendly, conversational tone
- Be concise but informative (2-4 sentences)
- If asked to "explain like I'm 5", use very simple language and analogies
- Reference specific points from the document context when relevant
- If you don't know something, say so honestly

Your response:''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ??
          'I couldn\'t generate a response. Please try again.';
    } catch (e) {
      print('Chat error: $e');
      return 'Sorry, I encountered an error. Please try asking another question.';
    }
  }
}