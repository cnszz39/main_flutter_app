import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/common/common_scaffold.dart';
import 'package:main_flutter_app/models/cd.dart';
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
            .map((e) => CDCard(
                  cdJacketId: e.id,
                  cdJacketUrl: e.jacketImageUrl,
                  isLocalImage: e.isLocalImage,
                  title: e.title,
                  cdType: e.type,
                  description: e.description,
                  releaseDate: e.releaseDate.toString(),
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
  final String cdJacketId;
  final String cdJacketUrl;
  final bool isLocalImage;
  final String title;
  final String cdType;
  final String description;
  final String releaseDate;

  CDCard({
    this.cdJacketId,
    this.cdJacketUrl,
    this.isLocalImage,
    this.title,
    this.cdType,
    this.description,
    this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return CDDetailPage(
                jacketImageId: cdJacketId,
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
              tag: 'cd_jacket_image_$cdJacketId',
              child: isLocalImage
                  ? Image.asset(cdJacketUrl, width: 200, height: 200)
                  : Image.network(cdJacketUrl, width: 200, height: 200),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Container(
                  height: 200,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft, child: Text(title)),
                      Align(
                          alignment: Alignment.centerLeft, child: Text(cdType)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(description),
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
