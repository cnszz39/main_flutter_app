import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicGamePage extends StatefulWidget {
  @override
  _MusicGamePageState createState() => new _MusicGamePageState();
}

class _MusicGamePageState extends State<MusicGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [TabBar()],
      ),
    );
  }
}
