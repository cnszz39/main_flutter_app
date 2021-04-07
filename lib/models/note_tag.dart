class NoteTag {
  String name;

  NoteTag({this.name});

  NoteTag.fromMap(Map<String, dynamic> map) {
    print(map.toString());
    this.name = map['name'];
  }
}
