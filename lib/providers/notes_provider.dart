import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/database_service.dart';

class NotesProvider with ChangeNotifier {
  DatabaseService? _dbService;
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Note> get notes => _searchQuery.isEmpty ? _notes : _filteredNotes;
  bool get isLoading => _isLoading;

  void updateUserId(String? userId) {
    if (userId == null) {
      _dbService = null;
      _notes = [];
      _filteredNotes = [];
    } else {
      _dbService = DatabaseService(userId: userId);
      _listenToNotes();
    }
    notifyListeners();
  }

  void _listenToNotes() {
    _isLoading = true;
    _dbService?.notes.listen((notes) {
      _notes = notes;
      _filterNotes();
      _isLoading = false;
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterNotes();
    notifyListeners();
  }

  void _filterNotes() {
    if (_searchQuery.isEmpty) {
      _filteredNotes = [];
    } else {
      _filteredNotes = _notes
          .where((note) =>
              note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              note.content.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  Future<void> addNote(String title, String content) async {
    await _dbService?.createNote(title, content);
  }

  Future<void> updateNote(String id, String title, String content) async {
    await _dbService?.updateNote(id, title, content);
  }

  Future<void> deleteNote(String id) async {
    await _dbService?.deleteNote(id);
  }
}
