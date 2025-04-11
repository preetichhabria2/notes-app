import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add Note
  Future<void> addNote(String title, String content, String userId) async {
    try {
      await _db.collection('notes').add({
        'title': title,
        'content': content,
        'userId': userId, // Store the userId along with the note
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception("Error adding note: $e");
    }
  }

  // Get all Notes for the current user
  Future<List<Map<String, dynamic>>> getNotes(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _db
              .collection('notes')
              .where('userId', isEqualTo: userId)
              .get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'content': doc['content'],
          'createdAt': doc['createdAt'],
        };
      }).toList();
    } catch (e) {
      throw Exception("Error fetching notes: $e");
    }
  }

  // Delete Note
  Future<void> deleteNote(String noteId) async {
    try {
      await _db.collection('notes').doc(noteId).delete();
    } catch (e) {
      throw Exception("Error deleting note: $e");
    }
  }

  // Update Note
  Future<void> updateNote(String noteId, String title, String content) async {
    try {
      await _db.collection('notes').doc(noteId).update({
        'title': title,
        'content': content,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception("Error updating note: $e");
    }
  }

  // Stream Notes (Real-time updates)
  Stream<QuerySnapshot> getNotesStream() {
    return _db.collection('notes').snapshots();
  }
}
