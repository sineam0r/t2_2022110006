import 'package:flutter/material.dart';
import 'package:t2_2022110006/models/note.dart';

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];
  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void editNote(Note note) {
    final index = _notes.indexWhere((element) => element.id == note.id);
    _notes[index] = note;
    notifyListeners();
  }

  void removeNote(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  void clearNotes() {
    _notes.clear();
    notifyListeners();
  }
}