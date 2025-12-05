// lib/models/item.dart
class Item {
  String? id;
  final String name;
  final String category;
  final bool checked;

  Item({
    this.id,
    required this.name,
    required this.category,
    this.checked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "checked": checked,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id']?.toString(),
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? 'Uncategorized',
      checked: map['checked'] == true || map['checked'] == 'true',
    );
  }
}
