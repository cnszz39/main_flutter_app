class Note {
  String id;
  String title;
  String content;

  Note({this.id, this.title, this.content});

  Note.fromMap(Map<String, dynamic> map, String id) {
    this.id = id;
    this.title = map['title'];
    this.content = map['content'];

  }
}