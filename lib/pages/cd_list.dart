import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/common/common_scaffold.dart';
import 'package:main_flutter_app/models/cd.dart';
import 'package:main_flutter_app/models/music.dart';
import 'package:main_flutter_app/pages/cd_detail.dart';

class CDListPage extends StatefulWidget {
  bool isListView = true;

  CDListPageState createState() => new CDListPageState();
}

class CDListPageState extends State<CDListPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      strTitle: 'CDリスト',
      bodyWidget: ListView(
        children: getCDData()
            .map((e) =>
            CDCard(
              objCD: e,
            ))
            .toList(),
      ),
      appBarActions: [
        IconButton(
          icon: Icon(widget.isListView ? Icons.grid_on : Icons.list),
          onPressed: () {
            setState(() {
              widget.isListView = !widget.isListView;
            });
          },
        )
      ],
    );
  }
}

class CDCard extends StatelessWidget {
  final CD objCD;

  CDCard({this.objCD});

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
  }
}

class CDGridTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridTile(child: null);
  }
}

List<CD> getCDData() {
  // TODO Change data source to firebase
  List<CD> dataList = [];
  for (var i = 1; i <= 10; i++) {
    dataList.add(new CD(
      id: i.toString(),
      jacketImageUrl: 'images/jacket_sc_0004.jpg',
      title: 'No Limit RED Force',
      type: 'サウンドコレクション',
      description: '詳細',
      releaseDate: DateTime.now(),
      musics: [
        Music(
          trackNum: 1,
          title: 'No Limit RED Force',
          artistName: '',
        ),
        Music(
          trackNum: 2,
          title: 'Sparkle',
          artistName: '',
        ),
        Music(
          trackNum: 3,
          title: 'Last Kingdom',
          artistName: '',
        ),
        Music(
          trackNum: 4,
          title: 'Vibes 2k20',
          artistName: '',
        ),
        Music(
          trackNum: 5,
          title: 'R\'N\'R Monsta',
          artistName: '',
        ),
        Music(
          trackNum: 6,
          title: 'Ai Drew',
          artistName: '',
        ),
        Music(
          trackNum: 7,
          title: 'DAWNBREAKER',
          artistName: '',
        ),
        Music(
          trackNum: 8,
          title: 'アマツカミ',
          artistName: '',
        ),
        Music(
          trackNum: 9,
          title: 'Galaxy Blaster',
          artistName: '',
        ),
        Music(
          trackNum: 10,
          title: 'Trinity Departure',
          artistName: '',
        ),
        Music(
          trackNum: 11,
          title: 'AstrøNotes.',
          artistName: '',
        ),
        Music(
          trackNum: 12,
          title: 'Singularity',
          artistName: '',
        ),
        Music(
          trackNum: 13,
          title: '脳天直撃',
          artistName: '',
        ),
        Music(
          trackNum: 14,
          title: 'No Limit RED Force（Game Size）',
          artistName: '',
        ),
        Music(
          trackNum: 15,
          title: 'No Limit RED Force - 星咲あかりソロver. -',
          artistName: '',
        ),
        Music(
          trackNum: 16,
          title: 'No Limit RED Force - 藍原 椿ソロver. -',
          artistName: '',
        ),
        Music(
          trackNum: 17,
          title: 'No Limit RED Force - 早乙女彩華ソロver. -',
          artistName: '',
        ),
        Music(
          trackNum: 18,
          title: 'No Limit RED Force - 柏木咲姫ソロver. -',
          artistName: '',
        ),
        Music(
          trackNum: 19,
          title: 'No Limit RED Force - 柏木美亜ソロver. -',
          artistName: '',
        ),
        Music(
          trackNum: 20,
          title: 'No Limit RED Force（instrumental）',
          artistName: '',
        ),
      ],
    ));
  }
  return dataList;
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
