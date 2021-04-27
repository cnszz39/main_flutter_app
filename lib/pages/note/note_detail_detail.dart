import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/note.dart';

class NoteDetailPage extends StatelessWidget {
  final Note currentNote;
  final bool isMobileDevice;
  NoteDetailPage({this.currentNote, this.isMobileDevice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobileDevice ? AppBar() : null,
      body: currentNote != null
          ? ListView(
              children: [
                // ListTile(
                //   title: Text(currentNote.title),
                // ),
                // ListTile(
                //   title: Text(currentNote.content),
                // ),
              ],
            )
          : Center(),
    );
  }
}
