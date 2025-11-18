class Item {
  String name;
  bool isChecked;

  Item({
    required this.name,
    this.isChecked = false,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'isChecked': isChecked,
  };

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] ?? '',
      isChecked: map['isChecked'] ?? false,
    );
  }
}
