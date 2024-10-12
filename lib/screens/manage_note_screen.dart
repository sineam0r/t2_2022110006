import 'package:flutter/material.dart';
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
        title: Text(isEdit ? 'Edit Note' : 'Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title'
              ),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Content'
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final content = contentController.text;

                if (title.isEmpty || content.isEmpty) {
                  return;
                }

                final newNote = Note(
                  id: isEdit
                    ? existingNote.id
                    : DateTime.now().millisecondsSinceEpoch,
                  title: title,
                  content: content,
                );

                if (isEdit) {
                  context.read<NoteProvider>().editNote(newNote);
                }
                context.read<NoteProvider>().addNote(newNote);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        )
      ),
    );
  }
}


