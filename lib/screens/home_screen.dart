import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t2_2022110006/providers/note_provider.dart';
import 'package:t2_2022110006/screens/manage_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(
                  Provider.of<NoteProvider>(context, listen: false),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManageNoteScreen(),
              ),
            );
          },
          label: const Text('Add New Note', style: TextStyle(color: Colors.white),),
          icon: const Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.black,
        ),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, value, child) {
          final notes = value.notes;
          final filteredNotes = _searchController.text.isEmpty
              ? notes
              : notes
                  .where((note) =>
                      note.title.toLowerCase().contains(
                            _searchController.text.toLowerCase(),
                          ))
                  .toList();

          if (filteredNotes.isEmpty) {
            return const Center(
              child: Text('No notes found'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];

                return Card(
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(note.content),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageNoteScreen(),
                        settings: RouteSettings(arguments: note),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NoteSearchDelegate extends SearchDelegate {
  final NoteProvider _noteProvider;

  NoteSearchDelegate(this._noteProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final notes = _noteProvider.notes
        .where((note) =>
            note.title.toLowerCase().contains(
                  query.toLowerCase(),
                ))
        .toList();

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return ListTile(
          title: Text(
            note.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(note.content),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageNoteScreen(),
              settings: RouteSettings(arguments: note),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final notes = _noteProvider.notes
        .where((note) =>
            note.title.toLowerCase().contains(
                  query.toLowerCase(),
                ))
        .toList();

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return ListTile(
          title: Text(
            note.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(note.content),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageNoteScreen(),
              settings: RouteSettings(arguments: note),
            ),
          ),
        );
      },
    );
  }
}

