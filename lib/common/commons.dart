import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/pages/all_pages.dart';

class ImageViewPage extends StatelessWidget {
  final String strImageUrl;
  final bool isLocalImage;

  ImageViewPage({this.strImageUrl, this.isLocalImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[400],
      appBar: AppBar(
        backgroundColor: Colors.brown[400].withOpacity(0),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: isLocalImage
            ? Image.asset(strImageUrl)
            : Image.network(strImageUrl),
      ),
    );
  }
}

List<Map<String, dynamic>> getMainPageConfig(BuildContext context, FirebaseFirestore firestore, FirebaseStorage firebaseStorage) => [
      {
        'pageIndex': 0,
        'pageName': 'ノート',
        'pageIcon': Icons.note,
        'pageWidget': NoteListPage(firestore: firestore,),
        'appBarActions': [],
      },
      {
        'pageIndex': 1,
        'pageName': 'CD',
        'pageIcon': Icons.library_music,
        'pageWidget': CDListPage(firestore: firestore, firebaseStorage: firebaseStorage,),
        'appBarActions': [],
      },
      {
        'pageIndex': 2,
        'pageName': 'ゲーム',
        'pageIcon': Icons.games,
        'pageWidget': GamesPage(),
        'appBarActions': [],
      },
      {
        'pageIndex': 3,
        'pageName': '設定',
        'pageIcon': Icons.settings,
        'pageWidget': SettingPage(),
        'appBarActions': [],
      },
    ];

class GameMenuItem {
  GameMenuItem({
    this.title,
    this.expandedValue,
    this.isExpanded,
    this.games,
  });
  String title;
  String expandedValue;
  bool isExpanded;
  List<GameItem> games;
}

class GameItem {
  GameItem({
    this.gameJacket,
    this.gameTitle,
    this.gameDescription,
  });
  Image gameJacket;
  String gameTitle;
  String gameDescription;
}

List<GameMenuItem> gameMenuItems() => [
      GameMenuItem(
        title: 'リズムゲーム（アーケード）',
        expandedValue: 'test',
        isExpanded: true,
        games: <GameItem>[
          GameItem(
            gameTitle: 'オンゲキ',
            gameDescription: 'オンゲキ',
            gameJacket: Image.asset('images/ongeki_logo.png'),
          ),
          GameItem(
            gameTitle: 'チュウニズム',
            gameDescription: 'チュウニズム',
            gameJacket: Image.asset('images/jacket_sc_0004.jpg'),
          ),
        ],
      ),
      GameMenuItem(
        title: 'リズムゲーム（モバイル）',
        expandedValue: 'test',
        isExpanded: true,
        games: <GameItem>[
          GameItem(
            gameTitle: 'バンドリ',
            gameDescription: 'バンドリ',
            gameJacket: Image.asset('images/jacket_sc_0004.jpg'),
          ),
          GameItem(
            gameTitle: 'プロセカ',
            gameDescription: 'プロセカ',
            gameJacket: Image.asset('images/jacket_sc_0004.jpg'),
          ),
        ],
      ),
    ];
