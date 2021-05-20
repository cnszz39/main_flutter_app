import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main_flutter_app/models/note/note_tag.dart';

class Note {
  String id;
  String title;
  String content;
  List<NoteTag> tags;

  Note({this.id, this.title, this.content, this.tags});

  Note.fromMap(Map<String, dynamic> map, String id) {
    // List<DocumentReference> currentTagReferences = map['tags'];
    // currentTagReferences.map((e) => {
    //   e.get().then((value) => {
    //     value.data()
    //   })
    // });

    // List<NoteTag> currentTags = currentTagReferences.map((e) => {e.get().then((value) => {value.data()})});

    this.id = id;
    this.title = map['title'];
    this.content = map['content'];
    // this.tags = currentTagReferences;
  }

  Future<QuerySnapshot> getNotes(FirebaseFirestore fireStore) async {
    return await fireStore
        .collection('notes')
        .where('title', isNotEqualTo: '')
        .get();
  }

  Future<QuerySnapshot> getNote(
      FirebaseFirestore firestore, String noteId) async {
    return await firestore
        .collection('notes')
        .where('id', isEqualTo: noteId)
        .get();
  }
}
