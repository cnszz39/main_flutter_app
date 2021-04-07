import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/note.dart';

class NoteDetailPage extends StatelessWidget {
  final Note currentNote;

  NoteDetailPage({this.currentNote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: Text(currentNote.title),
          ),
          ListTile(
            title: Text(currentNote.content),
          ),
        ],
      ),
    );
  }
}
