import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:t2_2022110006/providers/note_provider.dart';
import 'package:t2_2022110006/models/folder.dart';

class ManageFolderScreen extends StatelessWidget {
  const ManageFolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    final existingFolder =
      ModalRoute.of(context)!.settings.arguments as Folder?;
    final isEdit = existingFolder != null;

    if (isEdit) {
      nameController.text = existingFolder.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Folder' : 'Add Folder',
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
                  context.read<NoteProvider>().removeFolder(existingFolder);
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
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Folder Name',
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
                final name = nameController.text;

                if (name.isEmpty) {
                  return;
                }

                if (isEdit) {
                  context.read<NoteProvider>().editFolder(
                    Folder(
                      id: existingFolder.id,
                      name: name,
                      notes: existingFolder.notes,
                    ),
                  );
                } else {
                  context.read<NoteProvider>().addFolder(
                    Folder(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: name,
                      notes: [],
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
            ),
          ]
        )
      )
    );
  }
}