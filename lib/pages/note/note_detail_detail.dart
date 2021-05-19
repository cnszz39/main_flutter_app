import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/common/responsive_page.dart';
import 'package:main_flutter_app/main.dart';
import 'package:main_flutter_app/models/note/note.dart';

class NoteDetailPage extends StatefulWidget {
  final Note currentNote;
  bool isEdit = false;
  bool isFavorite = false;
  String noteCollectionByUserId = '';
  final FirebaseFirestore firestore;

  NoteDetailPage({this.currentNote, this.firestore});

  NoteDetailPageState createState() => new NoteDetailPageState();
}

class NoteDetailPageState extends State<NoteDetailPage> {
  DocumentReference noteReference;

  DocumentReference userReference;

  @override
  void initState() {
    super.initState();
    noteReference = firestore.doc('note/${widget.currentNote.id}');
    userReference = firestore.doc('user/7EIgrvyTNLX5RWJtAsI5aF0jXaJ3');

    firestore
        .collection('note_collection_by_user')
        .where('note', isEqualTo: noteReference)
        .where('user', isEqualTo: userReference)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        setState(() {
          widget.isFavorite = true;
          widget.noteCollectionByUserId = value.docs[0].id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController noteTitleController = new TextEditingController();
    noteTitleController.text = widget.currentNote.title;
    TextEditingController noteContentController = new TextEditingController();
    noteContentController.text = widget.currentNote.content;

    return ResponsivePage(
      mobilePage: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                setState(() {
                  widget.isFavorite = !widget.isFavorite;
                });

                if (!widget.isFavorite) {
                  widget.firestore
                      .doc(
                          'note_collection_by_user/${widget.noteCollectionByUserId}')
                      .delete();
                  widget.noteCollectionByUserId = '';
                } else {
                  widget.firestore
                      .collection('note_collection_by_user')
                      .add({'note': noteReference, 'user': userReference}).then(
                          (value) {
                    setState(() {
                      widget.noteCollectionByUserId = value.id;
                      widget.isFavorite = true;
                    });
                  });
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(widget.isEdit ? Icons.save : Icons.edit_outlined),
          onPressed: () {
            setState(() {
              widget.isEdit = !widget.isEdit;
            });

            if (!widget.isEdit) {
              FocusScope.of(context).unfocus();
              noteTitleController.text = noteTitleController.text;
              noteContentController.text = noteContentController.text;
              widget.currentNote.title = noteTitleController.text;
              widget.currentNote.content = noteContentController.text;

              widget.firestore
                  .collection('notes')
                  .doc(widget.currentNote.id)
                  .update({
                'title': noteTitleController.text,
                'content': noteContentController.text,
              });
            }
          },
        ),
        body: widget.currentNote != null
            ? Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: noteTitleController,
                      readOnly: !widget.isEdit,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: noteContentController,
                        readOnly: !widget.isEdit,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              )
            : Center(),
      ),
    );
  }
}
