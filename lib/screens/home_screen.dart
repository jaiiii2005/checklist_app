// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ models/item.dart';
import '../services/database_service.dart';
import 'smart_checklist_screen.dart';
import 'category_item_screen.dart';

class HomeScreen extends StatefulWidget {
  final String purpose;
  final String? tripId;

  const HomeScreen({
    super.key,
    required this.purpose,
    this.tripId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService db = DatabaseService();
  String? uid;
  String? tripId;

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

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    _loadTripId();
  }

  Future<void> _loadTripId() async {
    final id = widget.tripId ?? await db.findTripByPurpose(uid!, widget.purpose);
    setState(() => tripId = id);
  }

  Future<void> _openSmartChecklistAndRefresh({
    required List<Map<String, dynamic>> items,
    String? forTripId,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SmartChecklistScreen(
          purpose: widget.purpose,
          items: items,
          tripId: forTripId ?? tripId,
        ),
      ),
    );

    if (result != null && result is Map && result['tripId'] != null) {
      setState(() => tripId = result['tripId']);
    } else {
      final id = await db.findTripByPurpose(uid!, widget.purpose);
      setState(() => tripId = id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // 🔥 APP BAR WITH SETTINGS + LOGOUT
      appBar: AppBar(
        title: const Text("ReadySetGO"),
        backgroundColor: const Color(0xFF4A00E0),
        actions: [

          // ⚙ SETTINGS BUTTON
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),

          // 🚪 LOGOUT BUTTON
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text(
                        "Are you sure you want to logout and return to Login?"
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A00E0),
                        ),
                        child: const Text("Logout"),
                      )
                    ],
                  );
                },
              );

              if (shouldLogout == true) {
                await FirebaseAuth.instance.signOut();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),

      body: tripId == null ? _emptyState() : _tripBody(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A00E0),
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryItemScreen(
                purpose: widget.purpose,
                initialSelectedItems: [],
              ),
            ),
          );

          if (result != null && result is List) {
            final converted = result.map<Map<String, dynamic>>((it) {
              if (it is String) {
                return {"name": it, "category": "General", "checked": false};
              }
              if (it is Map) {
                return {
                  "name": it["name"],
                  "category": it["category"],
                  "checked": it["checked"]
                };
              }
              return {"name": "", "category": "General", "checked": false};
            }).toList();

            await _openSmartChecklistAndRefresh(items: converted);
          } else {
            final id = await db.findTripByPurpose(uid!, widget.purpose);
            if (id != null) setState(() => tripId = id);
          }
        },
      ),
    );
  }

  // ---------------------------- TRIP BODY ----------------------------
  Widget _tripBody() {
    return StreamBuilder<List<Item>>(
      stream: db.getTripItems(uid!, tripId!),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snap.data!;
        final Map<String, List<Item>> grouped = {};

        for (var it in items) {
          final cat = it.category ?? "Uncategorized";
          grouped.putIfAbsent(cat, () => []);
          grouped[cat]!.add(it);
        }

        final total = items.length;
        final packed = items.where((i) => i.checked).length;
        final progress = total == 0 ? 0.0 : (packed / total);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(progress),
              const SizedBox(height: 20),

              // ----------------- CATEGORY GRID -----------------
              const Text(
                "Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat["icon"], size: 26, color: const Color(0xFF4A00E0)),
                        const SizedBox(height: 6),
                        Text(
                          cat["label"],
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),
              _buildAIMessage(progress),

              const SizedBox(height: 25),
              const Text("My Packing Checklist",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // ----------------- CHECKLIST DISPLAY -----------------
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: grouped.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),

                          ...entry.value.map((it) {
                            return ListTile(
                              leading: Icon(
                                it.checked
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: const Color(0xFF4A00E0),
                              ),
                              title: Text(it.name),
                              onTap: () async {
                                final structured = grouped.entries
                                    .expand((e) => e.value.map((i) => {
                                  "name": i.name,
                                  "category": e.key,
                                  "checked": i.checked,
                                }))
                                    .toList();

                                await _openSmartChecklistAndRefresh(
                                  items: structured,
                                  forTripId: tripId,
                                );
                              },
                            );
                          }),

                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------- EMPTY STATE ----------------------------
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("No trip found for '${widget.purpose}'.",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A00E0),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryItemScreen(
                    purpose: widget.purpose,
                    initialSelectedItems: [],
                  ),
                ),
              );

              if (result != null && result is List) {
                final converted = result.map<Map<String, dynamic>>((it) {
                  if (it is String) {
                    return {"name": it, "category": "General", "checked": false};
                  }
                  if (it is Map) {
                    return {
                      "name": it["name"],
                      "category": it["category"],
                      "checked": it["checked"],
                    };
                  }
                  return {"name": "", "category": "General", "checked": false};
                }).toList();

                await _openSmartChecklistAndRefresh(items: converted);
              } else {
                final id = await db.findTripByPurpose(uid!, widget.purpose);
                if (id != null) setState(() => tripId = id);
              }
            },
            child: const Text("Create Trip"),
          ),
        ],
      ),
    );
  }

  // ---------------------------- HEADER ----------------------------
  Widget _buildHeader(double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
        const LinearGradient(colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome Back 👋",
              style:
              TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16)),
          const SizedBox(height: 4),
          Text(widget.purpose,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
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
          Text("${(progress * 100).toInt()}% Packed",
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  // ---------------------------- AI MESSAGE ----------------------------
  Widget _buildAIMessage(double progress) {
    String message;

    if (progress < 0.3) {
      message = "🧳 Tip: Just starting! Pack essentials early.";
    } else if (progress < 0.7) {
      message = "✨ Halfway there! Don’t forget chargers and toiletries.";
    } else if (progress < 1.0) {
      message = "🔥 Almost done! Just a few items left.";
    } else {
      message = "✅ Perfect! Everything is packed!";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFF4A00E0)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13.5, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
