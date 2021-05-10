import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:main_flutter_app/models/cd/music.dart';

class CD {
  String id;
  String jacketImageUrl;
  String title;
  String type;
  String description;
  double price;
  bool isLocalImage;
  DateTime releaseDate;
  List<Music> musics;

  CD({
    this.id,
    this.jacketImageUrl,
    this.title,
    this.type,
    this.description,
    this.isLocalImage = true,
    this.releaseDate,
    this.price,
    this.musics,
  });

  CD.fromMap(
      Map<String, dynamic> map, String id, Reference jacketImageReference) {
    this.id = id;
    this.jacketImageUrl = 'images/jacket_sc_0004.jpg';
    this.title = map['title'];
    this.type = map['type'];
    this.description = map['description'];
    this.releaseDate = DateTime.parse(map['releaseDate']);
    this.price = map['price'];
    // jacketImageReference
    //     .getDownloadURL()
    //     .then((value) => this.jacketImageUrl = value);
  }

  Future<QuerySnapshot> getCDData(FirebaseFirestore fireStore) async {
    return await fireStore
        .collection('cds')
        .where('title', isNotEqualTo: '')
        .get();
  }

  // List<CD> getCDData() {
  //   // TODO Change data source to firebase
  //   List<CD> dataList = [];
  //   for (var i = 1; i <= 10; i++) {
  //     dataList.add(new CD(
  //       id: i.toString(),
  //       jacketImageUrl: 'images/jacket_sc_0004.jpg',
  //       title: 'No Limit RED Force',
  //       type: 'サウンドコレクション',
  //       description: '詳細',
  //       releaseDate: DateTime.now(),
  //       musics: [
  //         Music(
  //           trackNum: 1,
  //           title: 'No Limit RED Force',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 2,
  //           title: 'Sparkle',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 3,
  //           title: 'Last Kingdom',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 4,
  //           title: 'Vibes 2k20',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 5,
  //           title: 'R\'N\'R Monsta',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 6,
  //           title: 'Ai Drew',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 7,
  //           title: 'DAWNBREAKER',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 8,
  //           title: 'アマツカミ',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 9,
  //           title: 'Galaxy Blaster',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 10,
  //           title: 'Trinity Departure',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 11,
  //           title: 'AstrøNotes.',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 12,
  //           title: 'Singularity',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 13,
  //           title: '脳天直撃',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 14,
  //           title: 'No Limit RED Force（Game Size）',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 15,
  //           title: 'No Limit RED Force - 星咲あかりソロver. -',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 16,
  //           title: 'No Limit RED Force - 藍原 椿ソロver. -',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 17,
  //           title: 'No Limit RED Force - 早乙女彩華ソロver. -',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 18,
  //           title: 'No Limit RED Force - 柏木咲姫ソロver. -',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 19,
  //           title: 'No Limit RED Force - 柏木美亜ソロver. -',
  //           artistName: '',
  //         ),
  //         Music(
  //           trackNum: 20,
  //           title: 'No Limit RED Force（instrumental）',
  //           artistName: '',
  //         ),
  //       ],
  //     ));
  //   }
  //   return dataList;
  // }
}
