import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/commons.dart';
import 'package:main_flutter_app/models/note.dart';
import 'package:main_flutter_app/note_create_page.dart';
import 'package:main_flutter_app/pages/note_list.dart';
import 'package:main_flutter_app/search_view.dart';

FirebaseFirestore firestore;
FirebaseAuth firebaseAuth;
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
    firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.signInAnonymously();

    Future<QuerySnapshot> notes = Note().getNotes(firestore);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/note',
      routes: {
        '/note': (BuildContext context) => CommonScaffold(scaffoldBody: NoteListPage()),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) {
          return CommonScaffold(scaffoldBody: NoteListPage());
        },
      ),
    );
  }
}
