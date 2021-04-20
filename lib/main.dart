import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/note.dart';
import 'package:main_flutter_app/note_create_page.dart';
import 'package:main_flutter_app/pages/cd_list.dart';
import 'package:main_flutter_app/pages/note_list.dart';
import 'package:main_flutter_app/search_view.dart';

import 'common/commons.dart';

FirebaseFirestore firestore;
FirebaseAuth firebaseAuth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  int pageIndex = 0;

  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    firestore = FirebaseFirestore.instance;
    firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.signInAnonymously();

    // Future<QuerySnapshot> notes = Note().getNotes(firestore);

    List<Map<String, dynamic>> mainPages = getMainPageConfig();
    List<Widget> drawerMenuItems = [];
    PageController _pageController =
        new PageController(initialPage: widget.pageIndex);
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
              title: Text(mainPages[widget.pageIndex]['pageName'] as String),
              actions: [
                IconButton(
                  icon: Hero(
                    child: Icon(Icons.search),
                    tag: 'search_view',
                  ),
                  onPressed: () {
                    showSearch(context: context, delegate: SearchView());
                  },
                )
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: mainPages
                    .map(
                      (e) => ListTile(
                        title: Text(e['pageName'].toString()),
                        onTap: () {
                          setState(
                            () {
                              widget.pageIndex = e['pageIndex'];
                              _pageController.jumpToPage(e['pageIndex']);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            backgroundColor: Colors.white,
            body: PageView(
              controller: _pageController,
              children:
                  mainPages.map((e) => e['pageWidget'] as Widget).toList(),
            ),
          );
        },
      ),
    );
  }
}
