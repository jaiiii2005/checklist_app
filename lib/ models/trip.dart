import 'item.dart';

class Trip {
  String id;
  String purpose;
  List<Item> items;

  Trip({
    required this.id,
    required this.purpose,
    required this.items,
  });

  double get progress {
    if (items.isEmpty) return 0;
    int checked = items.where((i) => i.isChecked).length;
    return checked / items.length;
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'purpose': purpose,
    'items': items.map((e) => e.toMap()).toList(),
  };

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] ?? '',
      purpose: map['purpose'] ?? '',
      items: List<Item>.from(
        (map['items'] ?? []).map((e) => Item.fromMap(e)),
      ),
    );
  }
}
