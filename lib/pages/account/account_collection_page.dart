import 'package:flutter/material.dart';

class CollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('コレクション'),
          bottom: TabBar(
            tabs: [
              Tab(child: Text('CD')),
              Tab(child: Text('ノート')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Text('cd page'),
            ),
            Center(
              child: Text('note page'),
            ),
          ],
        ),
      ),
    );
  }
}
