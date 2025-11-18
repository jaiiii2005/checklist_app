import 'package:flutter/material.dart';

class PurposeSelectionScreen extends StatelessWidget {
  const PurposeSelectionScreen({super.key});

  // ✅ Predefined items for each trip type
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
      {
        "icon": Icons.flight_takeoff,
        "title": "Vacation Trip",
        "tag": "Relax and travel light"
      },
      {
        "icon": Icons.work,
        "title": "Business Trip",
        "tag": "Be ready for meetings"
      },
      {
        "icon": Icons.family_restroom,
        "title": "Family Trip",
        "tag": "Don’t forget the kids’ essentials"
      },
      {
        "icon": Icons.edit,
        "title": "Custom Trip",
        "tag": "Create your own checklist"
      },
      {
        "icon": Icons.terrain,
        "title": "Adventure Trip",
        "tag": "Hike, camp, and explore"
      },
      {
        "icon": Icons.weekend,
        "title": "Weekend Getaway",
        "tag": "Pack light & chill"
      },
      {
        "icon": Icons.celebration,
        "title": "Event / Wedding Trip",
        "tag": "Travel in style"
      },
      {
        "icon": Icons.public,
        "title": "International Trip",
        "tag": "Documents, currency & more"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Your Trip Purpose",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A00E0),
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: GridView.builder(
          itemCount: purposes.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 240,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.85,
          ),
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

  Widget _buildPurposeCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String tagline,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.white24,
      onTap: () {
        Navigator.pushNamed(
          context,
          '/smartChecklist', // ✅ Now routes to smart checklist
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
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tagline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
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
