import 'package:flutter/material.dart';

class PurposeSelectionScreen extends StatelessWidget {
  const PurposeSelectionScreen({super.key});

  // Preloaded checklists for each purpose
  final Map<String, List<String>> _purposeItems = const {
    "Vacation Trip": [
      "Casual wear",
      "Swimwear",
      "Sunglasses",
      "Sunscreen",
      "Camera"
    ],
    "Business Trip": [
      "Formal wear",
      "Laptop + charger",
      "Power bank",
      "Documents",
      "Business cards"
    ],
    "Family Trip": [
      "Kids’ clothes",
      "Snacks & water",
      "First aid kit",
      "Toys/books",
      "Extra shoes"
    ],
    "Custom Trip": [],
    "Adventure Trip": [
      "Hiking shoes",
      "Backpack",
      "Sleeping bag",
      "Torch",
      "Energy bars"
    ],
    "Weekend Getaway": [
      "2 sets of clothes",
      "Toiletries",
      "Snacks",
      "Power bank",
      "Travel pillow"
    ],
    "Event / Wedding Trip": [
      "Traditional wear",
      "Grooming kit",
      "Gifts",
      "Jewelry",
      "Comfortable shoes"
    ],
    "International Trip": [
      "Passport + Visa",
      "Currency & forex card",
      "Travel insurance",
      "Universal charger",
      "SIM card / roaming plan"
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> purposes = [
      {"icon": Icons.flight_takeoff, "title": "Vacation Trip", "tag": "Relax and travel light"},
      {"icon": Icons.work, "title": "Business Trip", "tag": "Be ready for meetings & travel"},
      {"icon": Icons.family_restroom, "title": "Family Trip", "tag": "Don’t forget the kids’ essentials"},
      {"icon": Icons.edit, "title": "Custom Trip", "tag": "Create your own checklist"},
      {"icon": Icons.terrain, "title": "Adventure Trip", "tag": "Camping, hiking, trekking gear"},
      {"icon": Icons.weekend, "title": "Weekend Getaway", "tag": "Light & minimal packing"},
      {"icon": Icons.celebration, "title": "Event / Wedding Trip", "tag": "Travel in style"},
      {"icon": Icons.public, "title": "International Trip", "tag": "Don’t miss the documents"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Purpose"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A00E0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: purposes.length,
          itemBuilder: (context, index) {
            final purpose = purposes[index];
            return _buildPurposeCard(
              context,
              icon: purpose["icon"],
              title: purpose["title"],
              tagline: purpose["tag"],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPurposeCard(BuildContext context,
      {required IconData icon, required String title, required String tagline}) {
    return InkWell(
      onTap: () {
        // ✅ Navigate to HomeScreen with preloaded checklist
        Navigator.pushNamed(
          context,
          '/home',
          arguments: {
            "purpose": title,
            "items": _purposeItems[title] ?? [],
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tagline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 