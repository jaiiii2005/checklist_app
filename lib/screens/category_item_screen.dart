import 'package:flutter/material.dart';

class CategoryItemScreen extends StatefulWidget {
  final String purpose;

  const CategoryItemScreen({
    super.key,
    required this.purpose, required List initialSelectedItems,
  });

  @override
  State<CategoryItemScreen> createState() => _CategoryItemScreenState();
}

class _CategoryItemScreenState extends State<CategoryItemScreen> {
  // ✅ All categories and their items (stored locally)
  final Map<String, dynamic> _items = {
    "Essentials": [
      "Passport",
      "Visa",
      {"Tickets": ["Air", "Bus", "Train"]},
      "Boarding pass",
      "Foreign currency",
      "Credit card",
      "Debit card",
      "Emergency money",
      "Travel insurance",
      "Money belt"
    ],
    "Clothing": [
      "Shirts",
      "T-shirts",
      "Polos",
      "Jeans",
      "Trousers",
      "Shorts",
      "Dresses",
      "Skirts",
      "Jackets",
      "Coats",
      "Raincoats",
      "Sleepwear",
      "Socks",
      "Underwear",
      "Belts",
      "Ties",
      "Scarves",
      "Gloves"
    ],
    "Electronics": [
      "Mobile phone",
      "Phone charger",
      "Laptop",
      "Tablet",
      "E-reader",
      "Camera",
      "Memory cards",
      "Headphones",
      "Earphones",
      "Power adapter",
      "Converter",
      "Flashlight",
      "Torch",
      "Power bank"
    ],
    "Toiletries": [
      "Toothbrush",
      "Toothpaste",
      "Floss",
      "Soap",
      "Shampoo",
      "Conditioner",
      "Deodorant",
      "Towels",
      "Tissues",
      "Toilet roll",
      "Makeup kit",
      "Shaving kit",
      "Hairbrush",
      "Comb",
      "Hair products",
      "Feminine hygiene products"
    ],
    "Footwear": [
      "Sneakers",
      "Sandals",
      "Slippers",
      "Formal shoes",
      "Hiking shoes",
      "Walking shoes",
      "Swim shoes",
      "Extra pair (backup)"
    ],
    "Accessories": [
      "Sunglasses",
      "Hat",
      "Cap",
      "Umbrella",
      "Daypack",
      "Small bag",
      "Jewelry (minimal)",
      "Travel pillow",
      "Eye mask",
      "Earplugs",
      "Luggage locks",
      "Luggage tags"
    ],
    "Watch": [
      "Wristwatch (analog)",
      "Wristwatch (digital)",
      "Smartwatch",
      "Smartwatch charger",
      "Extra watch straps"
    ],
    "Documents": [
      "Passport (original)",
      "Passport (copies)",
      "Visa papers",
      "Tickets",
      "Itinerary",
      "Driver’s license",
      "ID card",
      "Health insurance card",
      "Student card",
      "Digital copies (cloud/phone)"
    ],
  };

  // ✅ Keeps track of selected items
  final Map<String, Set<String>> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    for (var key in _items.keys) {
      _selectedItems[key] = {};
    }
  }

  void _toggleItem(String category, String item) {
    setState(() {
      if (_selectedItems[category]!.contains(item)) {
        _selectedItems[category]!.remove(item);
      } else {
        _selectedItems[category]!.add(item);
      }
    });
  }

  void _onDonePressed() {
    final selectedList = _selectedItems.entries
        .expand((e) => e.value)
        .toList();

    Navigator.pushNamed(
      context,
      '/smartChecklist',
      arguments: {
        "purpose": widget.purpose,
        "items": selectedList,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Your Packing Items",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A00E0),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _items.keys.map((category) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 3,
            child: ExpansionTile(
              collapsedBackgroundColor: const Color(0xFFF3E8FF),
              backgroundColor: const Color(0xFFF8F5FF),
              title: Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A00E0),
                ),
              ),
              children: _buildItemList(category, _items[category]),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A00E0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: _onDonePressed,
          child: const Text(
            "Done",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItemList(String category, dynamic items) {
    return items.map<Widget>((item) {
      if (item is String) {
        return CheckboxListTile(
          title: Text(item),
          activeColor: const Color(0xFF4A00E0),
          value: _selectedItems[category]!.contains(item),
          onChanged: (_) => _toggleItem(category, item),
        );
      } else if (item is Map<String, List<String>>) {
        String subCategory = item.keys.first;
        return ExpansionTile(
          title: Text(
            subCategory,
            style: const TextStyle(color: Color(0xFF4A00E0)),
          ),
          children: item[subCategory]!.map((subItem) {
            return CheckboxListTile(
              title: Text(subItem),
              activeColor: const Color(0xFF4A00E0),
              value: _selectedItems[category]!.contains(subItem),
              onChanged: (_) => _toggleItem(category, subItem),
            );
          }).toList(),
        );
      }
      return const SizedBox.shrink();
    }).toList();
  }
}
