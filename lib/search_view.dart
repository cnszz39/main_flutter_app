import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/note.dart';
import 'package:main_flutter_app/note_detail_detail.dart';

class SearchView extends SearchDelegate<Note> {
  final Future<QuerySnapshot> allSuggestions;

  SearchView({this.allSuggestions});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text('test'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: allSuggestions,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('there is no data'),
          );
        }

        List<Note> notes = snapshot.data.docs
            .map((e) => Note.fromMap(e.data(), e.id))
            .toList();
        notes.removeWhere((element) => !element.title.contains(query));
        return ListView(
          children: notes
              .map(
                (e) => ListTile(
                  title: Text(e.title),
                  onTap: () {
                    close(context, Note());
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return NoteDetailPage(
                            currentNote: e,
                            isMobileDevice: false,
                          );
                        },
                      ),
                    );
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}
