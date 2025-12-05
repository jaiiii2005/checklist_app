// lib/screens/category_item_screen.dart
import 'package:flutter/material.dart';

class CategoryItemScreen extends StatefulWidget {
  final String purpose;
  final List<String> initialSelectedItems;

  const CategoryItemScreen({
    super.key,
    required this.purpose,
    required this.initialSelectedItems,
  });

  @override
  State<CategoryItemScreen> createState() => _CategoryItemScreenState();
}

class _CategoryItemScreenState extends State<CategoryItemScreen> {
  final Map<String, dynamic> _items = {
    "Essentials": [
      "Passport",
      "Visa",
      {"Tickets": ["Air", "Bus", "Train"]},
      "Boarding pass",
      "Foreign currency",
      "Credit card"
    ],
    "Clothing": [
      "Shirts",
      "T-shirts",
      "Jeans",
      "Jackets",
      "Sleepwear",
      "Socks"
    ],
    "Electronics": [
      "Mobile phone",
      "Phone charger",
      "Laptop",
      "Headphones",
      "Power bank"
    ],
    "Toiletries": [
      "Toothbrush",
      "Toothpaste",
      "Soap",
      "Shampoo",
      "Deodorant"
    ],
    "Footwear": ["Sneakers", "Sandals", "Formal shoes"],
    "Accessories": ["Sunglasses", "Hat", "Umbrella", "Daypack"],
    "Watch": ["Wristwatch", "Smartwatch"],
    "Documents": ["Itinerary", "Driver’s license", "ID card"],
  };

  // track selected
  final Map<String, Set<String>> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    for (var k in _items.keys) _selectedItems[k] = {};
    for (var s in widget.initialSelectedItems) {
      // try to insert into first matching category (best-effort)
      bool inserted = false;
      for (var k in _items.keys) {
        final list = _items[k] as List;
        if (list.any((e) => (e is String && e == s) || (e is Map && e.values.first.contains(s)))) {
          _selectedItems[k]!.add(s);
          inserted = true;
          break;
        }
      }
      if (!inserted) {
        _selectedItems["Essentials"]!.add(s); // fallback
      }
    }
  }

  void _toggleItem(String cat, String item) {
    setState(() {
      if (_selectedItems[cat]!.contains(item))
        _selectedItems[cat]!.remove(item);
      else
        _selectedItems[cat]!.add(item);
    });
  }

  void _onDone() {
    // flatten selected into list of names
    final selected = _selectedItems.entries.expand((e) => e.value).toList();
    Navigator.pop(context, selected); // RETURN selected items to caller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Items"), backgroundColor: const Color(0xFF4A00E0)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: _items.keys.map((category) {
          final list = _items[category] as List;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A00E0))),
              children: list.map<Widget>((item) {
                if (item is String) {
                  return CheckboxListTile(
                    title: Text(item),
                    value: _selectedItems[category]!.contains(item),
                    onChanged: (_) => _toggleItem(category, item),
                    activeColor: const Color(0xFF4A00E0),
                  );
                } else if (item is Map) {
                  final key = item.keys.first;
                  return ExpansionTile(
                    title: Text(key, style: const TextStyle(color: Color(0xFF4A00E0))),
                    children: item[key]!.map<Widget>((sub) {
                      return CheckboxListTile(
                        title: Text(sub),
                        value: _selectedItems[category]!.contains(sub),
                        onChanged: (_) => _toggleItem(category, sub),
                        activeColor: const Color(0xFF4A00E0),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A00E0)),
          onPressed: _onDone,
          child: const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Text("Done")),
        ),
      ),
    );
  }
}
