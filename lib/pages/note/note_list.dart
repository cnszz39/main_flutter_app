import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main_flutter_app/common/responsive_page.dart';
import 'package:main_flutter_app/models/note/note.dart';
import 'package:main_flutter_app/pages/all_pages.dart';

// ignore: must_be_immutable
class NoteListPage extends StatefulWidget {
  bool isOpenNoteDetail = false;
  Note currentNote = Note();
  int currentNoteIndex = 0;

  final FirebaseFirestore firestore;

  NoteListPage({this.firestore});

  @override
  _NoteListPageState createState() => new _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage>
    with TickerProviderStateMixin {
  Future<QuerySnapshot> noteQuerySnapshot;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var noteQuerySnapshot = Note().getNotes(widget.firestore);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => NoteDetailPage(
                currentNote: null,
                firestore: widget.firestore,
              ),
            ),
          );
        },
      ),
      body: FutureBuilder(
        future: noteQuerySnapshot,
        builder: (BuildContext futureContext,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Container();

          return ResponsivePage(
            mobilePage: _mobilePage(snapshot.data.docs),
            tabletPage: _tabletPage(snapshot.data.docs),
            desktopPage: _desktopPage(snapshot.data.docs),
          );
        },
      ),
    );
  }

  Future<void> onRefreshNoteList() async {
    setState(() {
      noteQuerySnapshot = Note().getNotes(widget.firestore);
    });
  }

  Widget _noteCardItem(Note currentNote) => Card(
        child: ListTile(
          title: Text(
            currentNote.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            currentNote.content,
            style: TextStyle(fontSize: 16),
            maxLines: 2,
          ),
          trailing: Text('creator'),
          onTap: () {
            setState(() {
              widget.isOpenNoteDetail = !widget.isOpenNoteDetail;
              widget.currentNote = currentNote;
            });
            if (ResponsivePage.isMobile(context)) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    var begin = Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: NoteDetailPage(
                        currentNote: currentNote,
                        firestore: widget.firestore,
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      );

  Widget _mobilePage(List<QueryDocumentSnapshot> noteDocs) => RefreshIndicator(
        child: ListView(
          children: noteDocs
              .map((e) => _noteCardItem(Note.fromMap(e.data(), e.id)))
              .toList(),
        ),
        onRefresh: onRefreshNoteList,
      );

  Widget _tabletPage(List<QueryDocumentSnapshot> noteDocs) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        List<Widget> desktopPageWidgets = [];
        desktopPageWidgets.add(
          SizedBox(
            width: widget.isOpenNoteDetail ? 300 : constraints.maxWidth,
            child: RefreshIndicator(
              child: ListView(
                children: noteDocs
                    .map((e) => _noteCardItem(Note.fromMap(e.data(), e.id)))
                    .toList(),
              ),
              onRefresh: onRefreshNoteList,
            ),
          ),
        );

        if (widget.isOpenNoteDetail) {
          desktopPageWidgets.add(
            Expanded(
              child: NoteDetailPage(
                currentNote: widget.currentNote,
              ),
            ),
          );
        }

        return Row(
          children: desktopPageWidgets,
        );
      },
    );
  }

  Widget _desktopPage(List<QueryDocumentSnapshot> noteDocs) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        List<Widget> desktopPageWidgets = [];
        desktopPageWidgets.add(
          SizedBox(
            width: widget.isOpenNoteDetail ? 400 : constraints.maxWidth,
            child: RefreshIndicator(
              child: ListView(
                children: noteDocs
                    .map((e) => _noteCardItem(Note.fromMap(e.data(), e.id)))
                    .toList(),
              ),
              onRefresh: onRefreshNoteList,
            ),
          ),
        );

        if (widget.isOpenNoteDetail) {
          desktopPageWidgets.add(
            Expanded(
              child: NoteDetailPage(
                currentNote: widget.currentNote,
              ),
            ),
          );
        }

        return Row(
          children: desktopPageWidgets,
        );
      },
    );
  }
}
