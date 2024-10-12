import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:t2_2022110006/models/note.dart';
import 'package:t2_2022110006/providers/note_provider.dart';

class ManageNoteScreen extends StatelessWidget {
  const ManageNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    final existingNote =
      ModalRoute.of(context)!.settings.arguments as Note?;
    final isEdit = existingNote != null;

    if (isEdit) {
      titleController.text = existingNote.title;
      contentController.text = existingNote.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Note' : 'Add Note',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: isEdit
          ? [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<NoteProvider>().removeNote(existingNote);
                  Navigator.pop(context);
                },
              )
            ]
          : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                labelStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black
              ),
              onPressed: () {
                final title = titleController.text;
                final content = contentController.text;

                if (title.isEmpty || content.isEmpty) {
                  return;
                }

                if (isEdit) {
                  context.read<NoteProvider>().editNote(
                    Note(
                      id: existingNote.id,
                      title: title,
                      content: content,
                    ),
                  );
                } else {
                  context.read<NoteProvider>().addNote(
                    Note(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: title,
                      content: content,
                    ),
                  );
                }

                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}