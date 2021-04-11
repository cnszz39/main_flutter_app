import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CDDetailPage extends StatelessWidget {
  final String jacketImageId;

  CDDetailPage({this.jacketImageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (context) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.blueAccent.withOpacity(0),
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('CD Title'),
                background: Hero(tag: 'cd_jacket_image_$jacketImageId', child: Image.asset(
                  'images/jacket_sc_0004.jpg',
                  fit: BoxFit.cover,
                )),
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return Text('test');
              }, childCount: 2),
            ),
          ],
        );
      },
    ));
  }
}
