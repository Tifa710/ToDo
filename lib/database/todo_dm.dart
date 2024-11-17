class TodoDM {
  static const String collectionName = 'todo';
  String id;
  String title;
  String description;
  DateTime dateTime;
  bool isDone;

  TodoDM({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.isDone,
  });
  Map<String, dynamic> toFireStore() => {
        'id': id,
        'title': title,
        'description': description,
        'dateTime': dateTime,
        'isDone': isDone,
      };

  Map<String, dynamic> toJson() {
    Map<String, dynamic> dataJson = {
      'id': id, //
      'title': title,
      'description': description,
      'dateTime': dateTime,
      'isDone': isDone,
    };
    return dataJson;
  }

  TodoDM.fromJson(Map<String, dynamic> data)
      : this(
          id: data['id'],
          title: data['title'],
          description: data['description'],
          dateTime: data['dateTime'].toDate(),
          // From timeStamp to DateTime
          isDone: data['isDone'],
        );

  TodoDM.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data['id'],
          title: data['title'],
          description: data['description'],
          dateTime: data['dateTime'].toDate(),
          isDone: data['isDone'],
        );
}
