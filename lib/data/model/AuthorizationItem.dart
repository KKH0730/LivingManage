class AuthorizationItem {
  String id;
  String title;
  String content;
  String answer;
  int timestamp;
  List<String> imageUrls;

  AuthorizationItem({ required this.id, required this.title, required this.content, required this.answer, required this.timestamp, required this.imageUrls});

  factory AuthorizationItem.fromMap(Map<String, dynamic> map) {
    return AuthorizationItem(
        id: map['id'],
        title: map['title'],
        content: map['content'],
        answer: map['answer'],
        timestamp: map['timestamp'],
        imageUrls: (map['imageUrls'] as List<dynamic>).map((e) => e.toString()).toList()
    );
  }
}