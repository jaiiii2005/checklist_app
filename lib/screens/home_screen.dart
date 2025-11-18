import 'package:flutter/material.dart';
import 'category_item_screen.dart';

class HomeScreen extends StatelessWidget {
  final String purpose;
  final List<String> selectedItems;
  final double progress;

  const HomeScreen({
    super.key,
    required this.purpose,
    required this.selectedItems,
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"icon": Icons.checkroom, "label": "Clothing"},
      {"icon": Icons.devices, "label": "Electronics"},
      {"icon": Icons.bathtub, "label": "Toiletries"},
      {"icon": Icons.directions_walk, "label": "Footwear"},
      {"icon": Icons.shopping_bag, "label": "Accessories"},
      {"icon": Icons.watch, "label": "Watch"},
      {"icon": Icons.insert_drive_file, "label": "Documents"},
      {"icon": Icons.flight_takeoff, "label": "Essentials"},
    ];

    // Remove duplicates for display
    final List<String> allItems = selectedItems.toSet().toList();
    int packedCount = allItems.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("ReadySetGO"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A00E0),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header with progress
            _buildHeader(progress),
            const SizedBox(height: 18),

            // AI assistant tip
            _buildAIMessage(progress),
            const SizedBox(height: 25),

            // Category Grid
            const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            _buildCategoryGrid(context, categories, allItems),

            const SizedBox(height: 30),

            // Combined checklist
            const Text("My Packing Checklist", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildChecklistCard(allItems, progress),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome Back 👋", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16)),
          const SizedBox(height: 4),
          Text("Your $purpose", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text("${(progress * 100).toInt()}% Packed", style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildAIMessage(double progress) {
    String message;
    if (progress < 0.3) {
      message = "🧳 Tip: Just starting! Pack essentials like documents or clothes early.";
    } else if (progress < 0.7) {
      message = "✨ Halfway there! Don’t forget chargers and toiletries.";
    } else if (progress < 1.0) {
      message = "🔥 Almost done! Just a few items left.";
    } else {
      message = "✅ Perfect! Everything is packed and ready.";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFF4A00E0)),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 13.5, color: Colors.black87, height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, List<Map<String, dynamic>> categories, List<String> selectedItems) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.9,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () async {
            // Navigate to CategoryItemScreen with existing items
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryItemScreen(
                  purpose: purpose,
                  initialSelectedItems: selectedItems,
                ),
              ),
            );

            // Return result to HomeScreen (refresh)
            if (result != null && result is List<String>) {
              selectedItems.clear();
              selectedItems.addAll(result.toSet());
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'], size: 22, color: const Color(0xFF4A00E0)),
                const SizedBox(height: 6),
                Text(category['label'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                const Text("Tap to view", style: TextStyle(fontSize: 10, color: Colors.black38)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChecklistCard(List<String> allItems, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${allItems.length} items packed", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Color(0xFF4A00E0)),
                title: Text(allItems[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
