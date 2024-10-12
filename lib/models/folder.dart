import 'package:t2_2022110006/models/note.dart';

class Folder {
  int id;
  String name;
  List<Note> notes;

  Folder({
    required this.id,
    required this.name,
    required this.notes,
  });
}