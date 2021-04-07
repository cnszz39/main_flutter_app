import 'package:firebase_storage/firebase_storage.dart';

class CD {
  String title;
  String jacketImageUrl;

  CD({this.title, this.jacketImageUrl});

  CD.fromMap(Map<String, dynamic> map, Reference jacketImageReference) {
    this.title = map['title'];
    jacketImageReference
        .getDownloadURL()
        .then((value) => this.jacketImageUrl = value);
  }
}
