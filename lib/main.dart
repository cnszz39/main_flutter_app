import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/note.dart';
import 'package:main_flutter_app/note_create_page.dart';
import 'package:main_flutter_app/search_view.dart';

import 'note_detail_detail.dart';

FirebaseFirestore firestore;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    firestore = FirebaseFirestore.instance;

    Future<QuerySnapshot> notes = getNoteData(firestore);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('MyApp'),
              actions: [
                IconButton(
                  icon: Hero(
                    child: Icon(Icons.search),
                    tag: 'search_view',
                  ),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: SearchView(allSuggestions: notes));
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Text('Drawer Header'),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('ノート'),
                  )
                ],
              ),
            ),
            body: HomePage(
              noteQuerySnapshot: notes,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.create),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return NoteCreatePage();
                  }),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  Future<QuerySnapshot> noteQuerySnapshot;

  HomePage({this.noteQuerySnapshot});

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.noteQuerySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Container();

        return RefreshIndicator(
            child: ListView(
              children: snapshot.data.docs.map(
                (e) {
                  var tmpNote = Note.fromMap(e.data(), e.id);
                  return ListTile(
                    title: Text(
                      tmpNote.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      tmpNote.content,
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Text('creator'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return NoteDetailPage(
                              noteId: e.id,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
            onRefresh: onRefreshNoteList);
      },
    );
  }

  Future<void> onRefreshNoteList() async {
    setState(() {
      widget.noteQuerySnapshot = getNoteData(firestore);
    });
  }
}

Future<QuerySnapshot> getNoteData(FirebaseFirestore firestore) async {
  return await firestore
      .collection('notes')
      .where('title', isNotEqualTo: '')
      .get();
}
