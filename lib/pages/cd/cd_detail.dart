import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:main_flutter_app/models/cd/cd.dart';
import 'package:main_flutter_app/common/commons.dart';

class CDDetailPage extends StatefulWidget {
  final String jacketImageId;
  final CD objCD;
  bool isFavorite;

  CDDetailPage({this.jacketImageId, this.objCD, this.isFavorite = false});

  CDDetailPageState createState() => new CDDetailPageState();
}

class CDDetailPageState extends State<CDDetailPage> {
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
                    tag: 'cd_jacket_image_${widget.jacketImageId}',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => ImageViewPage(
                                  isLocalImage: true,
                                  strImageUrl: 'images/jacket_sc_0004.jpg',
                                )));
                      },
                      child: Image.asset(
                        'images/jacket_sc_0004.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
            TabBarViewCDDetailPage(objCD: widget.objCD),
            TabBarViewCDTrackListView(objCD: widget.objCD),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(widget.isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          setState(() {
            widget.isFavorite = !widget.isFavorite;
          });
        },
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
        children: objCD.musics
            .map(
              (e) => ListTile(
                leading: Text("${e.trackNum.toString().padLeft(2, '0')}."),
                title: Text(e.title),
                subtitle: Text(e.artistName),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return musicDetailSheet();
                    },
                  );
                },
              ),
            )
            .toList(),
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

Widget musicDetailSheet() => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (BuildContext context, ScrollController controller) {
        return SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [],
          ),
        );
      },
    );
