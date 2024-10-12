import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Notes App',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                child: Text(
                  'All Notes',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Folders',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ManageNoteScreen(),
                ),
              );
            },
            label: Text(
              'Add New Note',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
          ),
        ),
        body: TabBarView(
          children: [
            Consumer<NoteProvider>(
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
                  return Center(
                    child: Text(
                      'No notes found',
                      style: GoogleFonts.poppins(),
                    ),
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
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            note.content,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
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
            Center(
              child: Text(
                'No folders found',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
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
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            note.content,
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
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
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            note.content,
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const ManageNoteScreen(),
              settings: RouteSettings(arguments: note),
            ),
          ),
        );
      },
    );
  }
}
