import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t2_2022110006/models/note.dart';

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];
  List<Note> get notes => _notes;

  NoteProvider() {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString('notes');
    if (notesString != null) {
      final List<dynamic> notesJson = json.decode(notesString);
      _notes.addAll(notesJson.map((json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
      )).toList());
      notifyListeners();
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = json.encode(_notes.map((note) => {
      'id': note.id,
      'title': note.title,
      'content': note.content,
    }).toList());
    prefs.setString('notes', notesJson);
  }

  void addNote(Note note) {
    _notes.add(note);
    _saveNotes();
    notifyListeners();
  }

  void editNote(Note note) {
    final index = _notes.indexWhere((element) => element.id == note.id);
    _notes[index] = note;
    _saveNotes();
    notifyListeners();
  }

  void removeNote(Note note) {
    _notes.remove(note);
    _saveNotes();
    notifyListeners();
  }

  void clearNotes() {
    _notes.clear();
    _saveNotes();
    notifyListeners();
  }
}