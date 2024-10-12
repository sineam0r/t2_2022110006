import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t2_2022110006/models/note.dart';
import 'package:t2_2022110006/models/folder.dart';

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];
  final List<Folder> _folders = [];

  List<Note> get notes => _notes;
  List<Folder> get folders => _folders;

  NoteProvider() {
    _loadNotes();
    _loadFolders();
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

  Future<void> _loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final foldersString = prefs.getString('folders');
    if (foldersString != null) {
      final List<dynamic> foldersJson = json.decode(foldersString);
      _folders.addAll(foldersJson.map((json) => Folder(
        id: json['id'],
        name: json['name'],
        notes: (json['notes'] as List<dynamic>).map((noteJson) => Note(
          id: noteJson['id'],
          title: noteJson['title'],
          content: noteJson['content'],
        )).toList(),
      )).toList());
      notifyListeners();
    }
  }

  Future<void> _saveFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final foldersJson = json.encode(_folders.map((folder) => {
      'id': folder.id,
      'name': folder.name,
      'notes': folder.notes.map((note) => {
        'id': note.id,
        'title': note.title,
        'content': note.content,
      }).toList(),
    }).toList());
    prefs.setString('folders', foldersJson);
  }

  void addFolder(Folder folder) {
    _folders.add(folder);
    _saveFolders();
    notifyListeners();
  }

  void editFolder(Folder folder) {
    final index = _folders.indexWhere((element) => element.id == folder.id);
    _folders[index] = folder;
    _saveFolders();
    notifyListeners();
  }

  void removeFolder(Folder folder) {
    _folders.remove(folder);
    _saveFolders();
    notifyListeners();
  }
}