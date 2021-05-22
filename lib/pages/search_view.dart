import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main_flutter_app/models/all_models.dart';
import 'package:main_flutter_app/pages/all_pages.dart';

class SearchView extends SearchDelegate<Note> {
  final FirebaseFirestore firestore;

  SearchView({this.firestore});

  List<Note> noteSearchResults = [];

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
    return FutureBuilder(
      future: getSearchResult(query),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('there is no data'),
          );
        }
        return noteSearchResults.isNotEmpty ? ListView(
          children: noteSearchResults
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
                        firestore: firestore,
                      );
                    },
                  ),
                );
              },
            ),
          )
              .toList(),
        ) : Center(child: Text('There is no results.'),);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: getSearchResult(query),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('there is no data'),
          );
        }

        noteSearchResults = snapshot.data.docs
            .map((e) => Note.fromMap(e.data(), e.id))
            .toList();
        noteSearchResults
            .removeWhere((element) => !element.title.contains(query));
        return ListView(
          children: noteSearchResults
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
                            firestore: firestore,
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

  Future<QuerySnapshot> getSearchResult(String query) async {
    CollectionReference cfSearch = firestore.collection('notes');

    if (query != null && query.isNotEmpty) {
      cfSearch.where('title', arrayContainsAny: query.split(' '));
      cfSearch.where('content', arrayContainsAny: query.split(' '));
    }

    return await cfSearch.get();
  }
}
