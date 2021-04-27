import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/note.dart';
import 'package:main_flutter_app/pages/note/note_detail_detail.dart';

class NoteCreatePage extends StatelessWidget {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController textControllerTitle = TextEditingController();
  final TextEditingController textControllerContent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: Text('新規ノート'),
        actions: [
          ElevatedButton(
            child: Icon(Icons.save),
            onPressed: () {
              Map<String, Object> newNote = new Map();
              newNote['title'] = textControllerTitle.value.text;
              newNote['content'] = textControllerContent.value.text;
              fireStore
                  .collection('notes')
                  .add(newNote)
                  .then((value) => {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          Note newNote;
                          fireStore
                              .collection('notes')
                              .doc(value.id)
                              .get()
                              .then((value) => newNote =
                                  Note.fromMap(value.data(), value.id));
                          return NoteDetailPage(
                            currentNote: newNote,
                            isMobileDevice: false,
                          );
                        }))
                      })
                  .catchError((error) =>
                      print("add note failure, error: ${error.toString()}"));
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 16),
                labelStyle: TextStyle(fontSize: 16),
                fillColor: Colors.white,
                filled: true,
                hintText: 'タイトル',
              ),
              controller: textControllerTitle,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 16),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '内容',
                  border: InputBorder.none),
              controller: textControllerContent,
            ),
          ],
        ),
      ),
    );
  }
}
