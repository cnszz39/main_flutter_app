import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/common/responsive_page.dart';
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

class _NoteListPageState extends State<NoteListPage> with TickerProviderStateMixin{
  Future<QuerySnapshot> noteQuerySnapshot;

  @override
  Widget build(BuildContext context) {
    var noteQuerySnapshot = Note().getNotes(widget.firestore);

    final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    final Animation<double> _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

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

          return ResponsivePage(
            mobilePage: _mobilePage(snapshot.data.docs),
            tabletPage: _tabletPage(snapshot.data.docs),
            desktopPage: _desktopPage(snapshot.data.docs),
          );

          // return LayoutBuilder(
          //     builder: (BuildContext context, BoxConstraints constraints) {
          //   if (constraints.maxWidth <= 600) {
          //   } else {
          //     List<Widget> widgetsForWebDevice = [];
          //     widgetsForWebDevice.add(
          //       SizedBox(
          //         width: widget.isOpenNoteDetail ? 400 : constraints.maxWidth,
          //         child: RefreshIndicator(
          //           child: ListView(
          //             children: snapshot.data.docs
          //                 .map((e) => _noteCardItem(Note.fromMap(e.data(), e.id)))
          //                 .toList(),
          //           ),
          //           onRefresh: onRefreshNoteList,
          //         ),
          //       ),
          //     );
          //     if (widget.isOpenNoteDetail) {
          //       widgetsForWebDevice.add(
          //         Expanded(
          //           child: NoteDetailPage(
          //             currentNote: Note.fromMap(
          //                 snapshot.data.docs[widget.currentNoteIndex].data(),
          //                 snapshot.data.docs[widget.currentNoteIndex].id),
          //             isMobileDevice: constraints.maxWidth <= 600,
          //           ),
          //         ),
          //       );
          //     }
          //
          //     return Row(
          //       children: widgetsForWebDevice,
          //     );
          //   }
          // });
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
            Navigator.of(context).push(
              // MaterialPageRoute(
              //   builder: (BuildContext context) {
              //     return NoteDetailPage(
              //       currentNote: currentNote,
              //     );
              //   },
              // ),
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
          },
          // onTap: () {
          //   if (isMobileDevice) {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) {
          //           return NoteDetailPage(
          //             currentNote: Note.fromMap(
          //                 snapshot.data.docs[i].data(),
          //                 snapshot.data.docs[i].id),
          //             isMobileDevice: isMobileDevice,
          //           );
          //         },
          //       ),
          //     );
          //   } else {
          //     setState(() {
          //       widget.currentNote = Note.fromMap(
          //         snapshot.data.docs[i].data(),
          //         snapshot.data.docs[i].id,
          //       );
          //
          //       if (i == widget.currentNoteIndex) {
          //         widget.isOpenNoteDetail = !widget.isOpenNoteDetail;
          //       } else {
          //         widget.isOpenNoteDetail = true;
          //       }
          //       widget.currentNoteIndex = i;
          //     });
          //   }
          // },
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

  Widget _tabletPage(List<QueryDocumentSnapshot> noteDocs) => RefreshIndicator(
        child: ListView(
          children: noteDocs
              .map((e) => _noteCardItem(Note.fromMap(e.data(), e.id)))
              .toList(),
        ),
        onRefresh: onRefreshNoteList,
      );

  Widget _desktopPage(List<QueryDocumentSnapshot> noteDocs) => RefreshIndicator(
        child: ListView(
          children: noteDocs
              .map((e) => _noteCardItem(Note.fromMap(e.data(), e.id)))
              .toList(),
        ),
        onRefresh: onRefreshNoteList,
      );
}
