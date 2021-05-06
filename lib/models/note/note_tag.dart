class NoteTag {
  String name;

  NoteTag({this.name});

  NoteTag.fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
  }
}
