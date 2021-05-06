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
}
