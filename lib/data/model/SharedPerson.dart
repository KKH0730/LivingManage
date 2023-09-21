class SharedPerson {
  String id;
  String name;
  String profileUrl;

  SharedPerson({ required this.id, required this.name, required this.profileUrl});

  factory SharedPerson.fromMap(Map<String, dynamic> map) {
    return SharedPerson(
        id: map['id'],
        name: map['name'],
        profileUrl: map['profileUrl']
    );
  }
}