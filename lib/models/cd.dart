import 'package:firebase_storage/firebase_storage.dart';

class CD {
  String id;
  String jacketImageUrl;
  String title;
  String type;
  String description;
  bool isLocalImage;
  DateTime releaseDate;

  CD({
    this.id,
    this.jacketImageUrl,
    this.title,
    this.type,
    this.description,
    this.isLocalImage = true,
    this.releaseDate,
  });

  CD.fromMap(Map<String, dynamic> map, String id, Reference jacketImageReference) {
    this.id = id;
    this.jacketImageUrl = 'images/jacket_sc_0004.jpg';
    this.title = map['title'];
    this.type = map['type'];
    this.description = map['description'];
    this.releaseDate = DateTime.parse(map['releaseDate']);
    // jacketImageReference
    //     .getDownloadURL()
    //     .then((value) => this.jacketImageUrl = value);
  }
}
