import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:main_flutter_app/models/cd.dart';
import 'package:main_flutter_app/pages/cd_detail.dart';

final scaffoldState = GlobalKey<ScaffoldState>();

class CDListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:  scaffoldState,
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          GestureDetector(
            onTap: () {
              showBottomSheet(
                  context: scaffoldState.currentContext,
                  builder: (BuildContext context) {
                    return CDDetailPage();
                  });
            },
            child: GridTile(
              child: Hero(
                  tag: 'cd_jacket_image',
                  child: Image.asset('images/jacket_sc_0004.jpg')),
              footer: Text('test'),
            ),
          ),
        ],
      ),
    );
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
