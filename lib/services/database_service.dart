import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  DatabaseService({required this.userId});

  // Collection reference
  CollectionReference get _notesCollection => _db.collection('notes');

  // Create a note
  Future<void> createNote(String title, String content) async {
    final now = DateTime.now();
    await _notesCollection.add({
      'title': title,
      'content': content,
      'created_at': Timestamp.fromDate(now),
      'updated_at': Timestamp.fromDate(now),
      'user_id': userId,
    });
  }

  // Update a note
  Future<void> updateNote(String id, String title, String content) async {
    await _notesCollection.doc(id).update({
      'title': title,
      'content': content,
      'updated_at': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }

  // Get notes stream for current user
  Stream<List<Note>> get notes {
    return _notesCollection
        .where('user_id', isEqualTo: userId)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
