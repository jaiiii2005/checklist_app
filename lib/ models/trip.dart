class Trip {
  String? id;
  String title;
  String description;

  Trip({
    this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
  };

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map["id"],
      title: map["title"],
      description: map["description"],
    );
  }
}
