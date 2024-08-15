class Not {
  int? id;
  String title;
  String content;
  DateTime date;

  Not({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(), 
    };
  }

  factory Not.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate;


    if (map['date'] is String) {
      try {
        parsedDate = DateTime.parse(map['date']);
      } catch (e) {
        print('Date parsing error: $e');
        parsedDate = DateTime.now(); 
      }
    } else {
      parsedDate = DateTime.now(); 
    }

    return Not(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: parsedDate,
    );
  }
}
