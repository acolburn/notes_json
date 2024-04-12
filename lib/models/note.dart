class Note {
  late String title;
  late String content;

  Note(this.title, this.content);

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'] as String;
    content = json['content'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['content'] = content;
    return data;
  }
}
