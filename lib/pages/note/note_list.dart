import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/note/note.dart';
import 'note_create_page.dart';
import 'note_detail_detail.dart';

class NoteListPage extends StatefulWidget {
  bool isOpenNoteDetail = false;
  Note currentNote = Note();
  int currentNoteIndex = 0;

  final FirebaseFirestore firestore;
  NoteListPage({this.firestore});

  @override
  _NoteListPageState createState() => new _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  Future<QuerySnapshot> noteQuerySnapshot;

  @override
  Widget build(BuildContext context) {
    var noteQuerySnapshot = Note().getNotes(widget.firestore);

    Size deviceSize = MediaQuery.of(context).size;
    bool isMobileDevice = deviceSize.width <= 600;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => NoteCreatePage(),
            ),
          );
        },
      ),
      body: FutureBuilder(
        future: noteQuerySnapshot,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Container();

          var listViewChildren = <Widget>[];
          for (var i = 0; i < snapshot.data.docs.length; i++) {
            var tmpNote = Note.fromMap(
                snapshot.data.docs[i].data(), snapshot.data.docs[i].id);
            listViewChildren.add(
              Card(
                child: ListTile(
                  title: Text(
                    tmpNote.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    tmpNote.content,
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Text('creator'),
                  onTap: () {
                    if (isMobileDevice) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return NoteDetailPage(
                              currentNote: Note.fromMap(
                                  snapshot.data.docs[i].data(),
                                  snapshot.data.docs[i].id),
                              isMobileDevice: isMobileDevice,
                            );
                          },
                        ),
                      );
                    } else {
                      setState(() {
                        widget.currentNote = Note.fromMap(
                          snapshot.data.docs[i].data(),
                          snapshot.data.docs[i].id,
                        );

                        if (i == widget.currentNoteIndex) {
                          widget.isOpenNoteDetail = !widget.isOpenNoteDetail;
                        } else {
                          widget.isOpenNoteDetail = true;
                        }
                        widget.currentNoteIndex = i;
                      });
                    }
                  },
                ),
              ),
            );
          }

          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth <= 600) {
              return RefreshIndicator(
                child: ListView(
                  children: listViewChildren,
                ),
                onRefresh: onRefreshNoteList,
              );
            } else {
              List<Widget> widgetsForWebDevice = [];
              widgetsForWebDevice.add(
                SizedBox(
                  width: widget.isOpenNoteDetail ? 400 : constraints.maxWidth,
                  child: RefreshIndicator(
                    child: ListView(
                      children: listViewChildren,
                    ),
                    onRefresh: onRefreshNoteList,
                  ),
                ),
              );
              if (widget.isOpenNoteDetail) {
                widgetsForWebDevice.add(
                  Expanded(
                    child: NoteDetailPage(
                      currentNote: Note.fromMap(
                          snapshot.data.docs[widget.currentNoteIndex].data(),
                          snapshot.data.docs[widget.currentNoteIndex].id),
                      isMobileDevice: constraints.maxWidth <= 600,
                    ),
                  ),
                );
              }

              return Row(
                children: widgetsForWebDevice,
              );
            }
          });
        },
      ),
    );
  }

  Future<void> onRefreshNoteList() async {
    setState(() {
      noteQuerySnapshot = Note().getNotes(widget.firestore);
    });
  }
}
