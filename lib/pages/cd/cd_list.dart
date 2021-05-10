// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/cd/cd.dart';
import 'package:main_flutter_app/pages/cd/cd_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> prefs;

class CDListPage extends StatefulWidget {
  bool isListView = true;

  final FirebaseFirestore firestore;

  CDListPage({this.firestore});

  CDListPageState createState() => new CDListPageState();
}

class CDListPageState extends State<CDListPage> {
  Future<QuerySnapshot> cdQuerySnapshot;

  @override
  void initState() {
    super.initState();

    prefs = SharedPreferences.getInstance();
    prefs.then((value) {
      if (value.getBool('cd_list_page_is_list') != null) {
        setState(() {
          widget.isListView = value.getBool('cd_list_page_is_list');
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    bool isMobileDevice = deviceSize.width <= 600;

    var cdQuerySnapshot =CD().getCDData(widget.firestore);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            FilterBar(),
            FutureBuilder(
                future: cdQuerySnapshot,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (!snap.hasData) return Container();

                  return Expanded(
                    child: isMobileDevice
                        ? ListView(
                            children: snap.data.docs
                                .map(
                                  (objCD) => cdListViewItem(
                                      context: context, objCD: CD.fromMap(objCD.data(), objCD.id, null)),
                                )
                                .toList(),
                          )
                        : GridView.count(
                            crossAxisCount: constraints.maxWidth ~/ 200,
                            children: snap.data.docs
                                .map(
                                  (objCD) => cdGridViewItem(objCD: CD.fromMap(objCD.data(), objCD.id, null)),
                                )
                                .toList(),
                          ),
                  );
                })
          ],
        );
      },
    );
  }
}

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.0,
      child: Material(
        type: MaterialType.card,
        color: Colors.white,
        elevation: 1.0,
        child: Container(
          margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
          child: Row(
            children: [
              DropdownButton(
                hint: Text('タイプ'),
                onChanged: (dynamic value) {
                  print(value);
                },
                items: [
                  DropdownMenuItem(
                      child: Text('サウンドトラック'), value: 'soundTrack'),
                  DropdownMenuItem(child: Text('ベストアルバム'), value: 'best'),
                  DropdownMenuItem(child: Text('キャラソング'), value: 'charactor'),
                ],
              ),
              DropdownButton(
                hint: Text('ソート順'),
                onChanged: (dynamic value) {
                  print(value);
                },
                items: [
                  DropdownMenuItem(child: Text('デフォルト'), value: 'default'),
                  DropdownMenuItem(child: Text('リリース日'), value: 'releaseDate'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget cdListViewItem({BuildContext context, CD objCD}) => GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return CDDetailPage(
                jacketImageId: objCD.id,
                objCD: objCD,
              );
            },
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(4.0),
        shape: BeveledRectangleBorder(),
        child: Row(
          children: [
            Hero(
              tag: 'cd_jacket_image_${objCD.id}',
              child: objCD.isLocalImage
                  ? Image.asset(objCD.jacketImageUrl, width: 200, height: 200)
                  : Image.network(objCD.jacketImageUrl,
                      width: 200, height: 200),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Container(
                  height: 200,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(objCD.title)),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(objCD.type)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(objCD.description),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

Widget cdGridViewItem({CD objCD}) => Padding(
      padding: EdgeInsets.all(8.0),
      child: GridTile(
        child: Hero(
          tag: 'cd_jacket_image_${objCD.id}',
          child: objCD.isLocalImage
              ? Image.asset(objCD.jacketImageUrl, width: 180, height: 180)
              : Image.network(objCD.jacketImageUrl, width: 180, height: 180),
        ),
        footer: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey.withOpacity(0.9),
                Colors.white.withOpacity(0.4),
              ],
            ),
          ),
          child: Text(
            objCD.title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );

class CDCardGrid extends StatelessWidget {
  final CD objCD;

  CDCardGrid({this.objCD});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return CDDetailPage(
                jacketImageId: objCD.id,
                objCD: objCD,
              );
            },
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(4.0),
        shape: BeveledRectangleBorder(),
        child: Column(
          children: [
            Hero(
              tag: 'cd_jacket_image_${objCD.id}',
              child: objCD.isLocalImage
                  ? Image.asset(objCD.jacketImageUrl, width: 180, height: 180)
                  : Image.network(objCD.jacketImageUrl,
                      width: 180, height: 180),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  objCD.title,
                  style: TextStyle(fontSize: 16.0),
                )),
          ],
        ),
      ),
    );
  }
}

class CDGridTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridTile(child: null);
  }
}

// class CDListPage extends StatelessWidget {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   FirebaseStorage firebaseStorage = FirebaseStorage.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     List<CD> cds = [];
//
//     return Scaffold(
//       body: FutureBuilder<QuerySnapshot>(
//         future:
//             firestore.collection('cds').where('title', isNotEqualTo: '').get(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           print(snapshot.hasData);
//           if (!snapshot.hasData) return Center(child: Text('there is no data'));
//
//           for (int i = 0; i < snapshot.data.size; i++) {
//             DocumentReference jacketImageReference =
//                 snapshot.data.docs[i].data()['jacket_image'];
//             cds.add(
//               CD.fromMap(
//                 snapshot.data.docs[i].data(),
//                 firebaseStorage.ref(
//                   jacketImageReference.path
//                       .replaceAll('gs:/mainflutterproject.appspot.com/', ''),
//                 ),
//               ),
//             );
//           }
//           return GridView.count(
//             crossAxisCount: 2,
//             children: cds
//                 .map((e) => GridTile(
//                     child: Image(
//                         image: CachedNetworkImageProvider(e.jacketImageUrl)),
//                     footer: Text(e.title)))
//                 .toList(),
//           );
//         },
//       ),
//     );
//   }
// }

List<Widget> listCdListAppBarActions() => [];
