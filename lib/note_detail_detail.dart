import 'package:flutter/material.dart';

class NoteDetailPage extends StatelessWidget {
  final String noteId;

  NoteDetailPage({this.noteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(noteId),
      ),
    );
  }
}
