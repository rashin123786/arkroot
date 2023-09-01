class TodoModel {
  String? documentId;
  String title;
  String description;
  String dateTime;
  bool isCompleted;
  TodoModel(
      {required this.dateTime,
      required this.description,
      required this.title,
      required this.isCompleted,
      this.documentId});

  factory TodoModel.fromjson(Map<String, dynamic> json, String documentId) {
    return TodoModel(
        documentId: documentId,
        isCompleted: json['isCheck'],
        dateTime: json['datetime'],
        description: json['description'],
        title: json['title']);
  }
}
