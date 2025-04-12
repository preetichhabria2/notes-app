import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add Note with tags and due date
  Future<void> addNote(
    String title,
    String content,
    String userId,
    List<String> tags,
    DateTime? dueDate, // ✅ Added dueDate parameter
  ) async {
    try {
      await _db.collection('notes').add({
        'title': title,
        'content': content,
        'userId': userId,
        'createdAt': Timestamp.now(),
        'dueDate':
            dueDate != null
                ? Timestamp.fromDate(dueDate)
                : null, // ✅ Store dueDate if provided
        'tags': tags,
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
          'dueDate':
              doc['dueDate'] != null
                  ? (doc['dueDate'] as Timestamp)
                      .toDate() // Convert Timestamp to DateTime
                  : null, // ✅ include dueDate in fetched data
          'tags': List<String>.from(doc['tags'] ?? []),
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

  // Update Note with tags and due date
  Future<void> updateNote(
    String noteId,
    String title,
    String content,
    List<String> tags,
    DateTime? dueDate, // ✅ include dueDate in update
  ) async {
    try {
      await _db.collection('notes').doc(noteId).update({
        'title': title,
        'content': content,
        'tags': tags,
        'dueDate':
            dueDate != null
                ? Timestamp.fromDate(dueDate)
                : null, // ✅ Store updated dueDate
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception("Error updating note: $e");
    }
  }

  // Stream Notes (Real-time updates) with tag filter
  Stream<QuerySnapshot> getNotesStream({String? tagFilter}) {
    CollectionReference notesRef = _db.collection('notes');

    if (tagFilter != null && tagFilter.isNotEmpty) {
      return notesRef.where('tags', arrayContains: tagFilter).snapshots();
    }

    return notesRef.snapshots();
  }
}
