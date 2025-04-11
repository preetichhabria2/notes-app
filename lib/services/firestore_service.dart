import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  // Add a new note
  Future<void> addNote(String title, String content) {
    return notes.add({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get stream of notes sorted by timestamp
  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  // Delete a note by document ID
  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }

  // Update an existing note by document ID
  Future<void> updateNote(String docId, String title, String content) {
    return notes.doc(docId).update({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
