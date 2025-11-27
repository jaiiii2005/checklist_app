class Item {
  String? id;
  String name;
  bool done;

  Item({
    this.id,
    required this.name,
    this.done = false,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "done": done,
  };

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map["id"],
      name: map["name"],
      done: map["done"] ?? false,
    );
  }
}
