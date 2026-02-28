import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentModel {
  final String id;
  final String fileName;
  final int fileSize;
  final String validity;
  final String validityMessage;
  final List<String> keyPoints;
  final List<String> importantNotices;
  final DateTime analyzedAt;

  DocumentModel({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.validity,
    required this.validityMessage,
    required this.keyPoints,
    required this.importantNotices,
    required this.analyzedAt,
  });

  factory DocumentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DocumentModel(
      id: doc.id,
      fileName: data['fileName'] ?? 'Unknown',
      fileSize: data['fileSize'] ?? 0,
      validity: data['validity'] ?? 'unknown',
      validityMessage: data['validityMessage'] ?? '',
      keyPoints: List<String>.from(data['keyPoints'] ?? []),
      importantNotices: List<String>.from(data['importantNotices'] ?? []),
      analyzedAt: (data['analyzedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fileName': fileName,
      'fileSize': fileSize,
      'validity': validity,
      'validityMessage': validityMessage,
      'keyPoints': keyPoints,
      'importantNotices': importantNotices,
      'analyzedAt': Timestamp.fromDate(analyzedAt),
    };
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final docDate = DateTime(analyzedAt.year, analyzedAt.month, analyzedAt.day);

    if (docDate == today) {
      return 'Today';
    } else if (docDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(analyzedAt).inDays < 7) {
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return weekdays[analyzedAt.weekday - 1];
    } else {
      return '${analyzedAt.day}/${analyzedAt.month}/${analyzedAt.year}';
    }
  }

  String get formattedTime {
    final hour = analyzedAt.hour.toString().padLeft(2, '0');
    final minute = analyzedAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get readableFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}