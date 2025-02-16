class Note {
  late int id;
  late String title;
  late String content;
  late DateTime modifiedTime;
  late String priority;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
    this.priority = 'Low',
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['content'] = content;
    map['modifiedTime'] = modifiedTime;
    map['priority'] = priority;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    content = map['content'];
    modifiedTime = map['modifiedTime'];
    priority = map['priority'];
  }
}
