import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:main_flutter_app/pages/cd_list.dart';
import 'package:main_flutter_app/pages/note_list.dart';

import '../note_create_page.dart';
import '../search_view.dart';

class CommonScaffold extends StatefulWidget {
  final Widget scaffoldBody;
  final Future<QuerySnapshot> notes;

  CommonScaffold({this.scaffoldBody, this.notes});

  _CommonScaffoldState createState() => new _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _handleSignIn();
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
                  delegate: SearchView(allSuggestions: widget.notes));
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
              title: GestureDetector(
                child: Text('ノート'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return NoteListPage();
                  }));
                },
              ),
            ),
            ListTile(
              title: GestureDetector(
                child: Text('CD'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CDListPage();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
      body: widget.scaffoldBody,
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
  }
}

List<Map<String, dynamic>> getMainPageConfig() => [
  {
    'pageIndex': 0,
    'pageName': 'ノート',
    'pageWidget': NoteListPage(),
    'appBarActions': [],
  },
  {
    'pageIndex': 1,
    'pageName': 'CD',
    'pageWidget': CDListPage(),
  },
];