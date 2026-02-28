import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/documents.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _userId => _auth.currentUser?.uid;

  static Future<void> saveDocument({
    required String fileName,
    required int fileSize,
    required Map<String, dynamic> analysis,
  }) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('documents')
          .add({
            'fileName': fileName,
            'fileSize': fileSize,
            'validity': analysis['validity'] ?? 'unknown',
            'validityMessage': analysis['validityMessage'] ?? '',
            'keyPoints': analysis['keyPoints'] ?? [],
            'importantNotices': analysis['importantNotices'] ?? [],
            'analyzedAt': FieldValue.serverTimestamp(),
          });

      print('Document saved to Firestore');
    } catch (e) {
      print('Error saving document: $e');
      rethrow;
    }
  }

  static Stream<List<DocumentModel>> getDocuments() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('documents')
        .orderBy('analyzedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => DocumentModel.fromFirestore(doc))
              .toList();
        });
  }

  static Future<void> deleteDocument(String documentId) async {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('documents')
          .doc(documentId)
          .delete();

      print('Document deleted from Firestore');
    } catch (e) {
      print('Error deleting document: $e');
      rethrow;
    }
  }

  static Future<int> getDocumentCount() async {
    if (_userId == null) return 0;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('documents')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting document count: $e');
      return 0;
    }
  }

  static Stream<List<DocumentModel>> searchDocuments(String query) {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('documents')
        .orderBy('analyzedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => DocumentModel.fromFirestore(doc))
              .where(
                (doc) =>
                    doc.fileName.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
        });
  }
}