import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/common/responsive_page.dart';
import 'package:main_flutter_app/main.dart';
import 'package:main_flutter_app/models/note/note.dart';

class NoteDetailPage extends StatefulWidget {
  final Note currentNote;
  bool isEdit = false;
  final FirebaseFirestore firestore;

  NoteDetailPage({this.currentNote, this.firestore});

  NoteDetailPageState createState() => new NoteDetailPageState();
}

class NoteDetailPageState extends State<NoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController noteTitleController = new TextEditingController();
    noteTitleController.text = widget.currentNote.title;
    TextEditingController noteContentController = new TextEditingController();
    noteContentController.text = widget.currentNote.content;

    return ResponsivePage(
      mobilePage: Scaffold(
        appBar: AppBar(),
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
