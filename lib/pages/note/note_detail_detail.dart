import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/common/responsive_page.dart';
import 'package:main_flutter_app/main.dart';
import 'package:main_flutter_app/models/note/note.dart';

class NoteDetailPage extends StatefulWidget {
  Note currentNote;
  final FirebaseFirestore firestore;

  NoteDetailPage({this.currentNote, this.firestore});

  bool isEdit = false;
  bool isFavorite = false;
  String noteCollectionByUserId = '';

  NoteDetailPageState createState() => new NoteDetailPageState();
}

class NoteDetailPageState extends State<NoteDetailPage> {
  DocumentReference noteReference;

  DocumentReference userReference;

  @override
  void initState() {
    super.initState();
    if (widget.currentNote != null) {
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
    } else {
      setState(() {
        widget.isEdit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController noteTitleController = new TextEditingController();
    TextEditingController noteContentController = new TextEditingController();

    noteTitleController.text =
        widget.currentNote != null ? widget.currentNote.title : '';
    noteContentController.text =
        widget.currentNote != null ? widget.currentNote.content : '';
    return Scaffold(
      appBar: !ResponsivePage.isDesktop(context)
          ? AppBar(
              actions: [
                IconButton(
                  icon: Icon(widget.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: widget.currentNote != null
                      ? () {
                          setState(() {
                            widget.isFavorite = !widget.isFavorite;
                          });
// TODO  fixed when set favorite from note Create Page
                          if (!widget.isFavorite) {
                            widget.firestore
                                .doc(
                                    'note_collection_by_user/${widget.noteCollectionByUserId}')
                                .delete();
                            widget.noteCollectionByUserId = '';
                          } else {

                            widget.firestore
                                .collection('note_collection_by_user')
                                .add({
                              'note': noteReference,
                              'user': userReference
                            }).then((value) {
                              setState(() {
                                widget.noteCollectionByUserId = value.id;
                                widget.isFavorite = true;
                              });
                            });
                          }
                        }
                      : null,
                ),
              ],
            )
          : null,
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

            if (widget.currentNote != null) {
              widget.firestore
                  .collection('notes')
                  .doc(widget.currentNote.id)
                  .update({
                'title': noteTitleController.text,
                'content': noteContentController.text,
              });
            } else {
              widget.firestore.collection('notes').add({
                'title': noteTitleController.text,
                'content': noteContentController.text
              }).then((value) {
                Note().getNote(widget.firestore, value.id).then((value) {
                  if (value.docs.length > 0) {
                    widget.currentNote =
                        Note.fromMap(value.docs[0].data(), value.docs[0].id);
                  }
                });
              });
            }

            if (widget.currentNote != null) {
              widget.currentNote.title = noteTitleController.text;
              widget.currentNote.content = noteContentController.text;
            } else {
              widget.currentNote = new Note(
                title: noteTitleController.text,
                content: noteContentController.text,
              );
            }


          }
        },
      ),
      body: Form(
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
      ),
    );
  }
}
