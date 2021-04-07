import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/note.dart';
import '../note_detail_detail.dart';

FirebaseFirestore fireStore;

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => new _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  Future<QuerySnapshot> noteQuerySnapshot;

  @override
  Widget build(BuildContext context) {
    fireStore = FirebaseFirestore.instance;
    var noteQuerySnapshot = Note().getNotes(fireStore);
    return Scaffold(body: FutureBuilder(
      future: noteQuerySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Container();

        var listViewChildren = <Widget>[];
        for (var i = 0; i < snapshot.data.docs.length; i++) {
          var tmpNote = Note.fromMap(snapshot.data.docs[i].data(), snapshot.data.docs[i].id);
          listViewChildren.add(ListTile(
            title: Text(
              tmpNote.title,
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              tmpNote.content,
              style: TextStyle(fontSize: 16),
            ),
            trailing: Text('creator'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return NoteDetailPage(
                      currentNote: Note.fromMap(snapshot.data.docs[i].data(), snapshot.data.docs[i].id),
                    );
                  },
                ),
              );
            },
          ));
        }
        return RefreshIndicator(
            child: ListView(
              children: listViewChildren,
            ),
            onRefresh: onRefreshNoteList);
      },
    ),);
  }

  Future<void> onRefreshNoteList() async {
    setState(() {
      noteQuerySnapshot = Note().getNotes(fireStore);
    });
  }
}
