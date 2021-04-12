import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:main_flutter_app/models/cd.dart';

class CDDetailPage extends StatelessWidget {
  final String jacketImageId;
  final CD objCD;

  CDDetailPage({this.jacketImageId, this.objCD});

  List<String> strTabBarNames = ['詳細', 'トラック'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: strTabBarNames.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.blue,
                pinned: true,
                floating: true,
                expandedHeight: 256.0,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('CD Title'),
                  background: Hero(
                      tag: 'cd_jacket_image_$jacketImageId',
                      child: Image.asset(
                        'images/jacket_sc_0004.jpg',
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  tabBar: TabBar(
                    labelColor: Colors.black,
                    tabs: strTabBarNames
                        .map((String name) => Tab(text: name))
                        .toList(),
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(children: [
            TabBarViewCDDetailPage(objCD: objCD),
            TabBarViewCDTrackListView(objCD: objCD),
          ]),
        ),
      ),
    );
  }
}

class TabBarViewCDDetailPage extends StatelessWidget {
  final CD objCD;

  TabBarViewCDDetailPage({this.objCD});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: ListView(
        children: [
          Row(
            children: [
              Text('タイプ'),
              SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  children: [
                    Chip(label: Text(objCD.type)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('アーティスト'),
              SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  children: [
                    Chip(label: Text(objCD.type)),
                  ],
                ),
              ),
            ],
          ),
          Text('詳細'),
          Text(objCD.description),
        ],
      ),
    );
  }
}

class TabBarViewCDTrackListView extends StatelessWidget {
  final CD objCD;

  TabBarViewCDTrackListView({this.objCD});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: ListView(
        children: ['track1', 'track2', 'track3'].map((e) => ListTile(title: Text(e),)).toList(),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate({this.tabBar});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
