// lib/screens/smart_checklist_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ models/item.dart';
import '../ models/trip.dart';
import '../services/database_service.dart';

class SmartChecklistScreen extends StatefulWidget {
  final String purpose;

  /// items can be List<Map> OR List<String>
  final List items;

  final String? tripId;

  const SmartChecklistScreen({
    super.key,
    required this.purpose,
    required this.items,
    this.tripId,
  });

  @override
  State<SmartChecklistScreen> createState() => _SmartChecklistScreenState();
}

class _SmartChecklistScreenState extends State<SmartChecklistScreen> {
  final DatabaseService db = DatabaseService();

  late List<Map<String, dynamic>> checklist;
  String? tripId;
  bool _loading = true;

  final TextEditingController _newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Convert raw items into proper map format
    checklist = widget.items.map<Map<String, dynamic>>((it) {
      if (it is String) {
        return {"name": it, "category": "General", "checked": false};
      } else if (it is Map) {
        return {
          "name": it["name"] ?? "",
          "category": it["category"] ?? "General",
          "checked": it["checked"] ?? false,
        };
      }
      return {"name": "", "category": "General", "checked": false};
    }).toList();

    tripId = widget.tripId;
    _loadExistingTripData();
  }

  Future<void> _loadExistingTripData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    tripId ??= await db.findTripByPurpose(uid, widget.purpose);

    if (tripId != null) {
      db.getTripItems(uid, tripId!).listen((firebaseItems) {
        setState(() {
          for (var fb in firebaseItems) {
            final index = checklist.indexWhere((x) => x["name"] == fb.name);

            if (index != -1) {
              checklist[index]["checked"] = fb.checked;
              checklist[index]["category"] = fb.category;
            } else {
              checklist.add({
                "name": fb.name,
                "category": fb.category,
                "checked": fb.checked,
              });
            }
          }
        });
      });
    }

    setState(() => _loading = false);
  }

  void _addNewItem(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      checklist.add({
        "name": text.trim(),
        "category": "Custom",
        "checked": false,
      });
    });

    _newItemController.clear();
  }

  Future<void> _saveChecklist() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    tripId ??= await db.addTrip(
      uid,
      Trip(purpose: widget.purpose, progress: 0.0),
    );

    int done = 0;

    for (var item in checklist) {
      final name = item["name"];
      final category = item["category"];
      final checked = item["checked"] ?? false;

      if (checked) done++;

      await db.addOrUpdateItem(
        uid,
        tripId!,
        Item(name: name, category: category, checked: checked),
      );
    }

    final double progress =
    checklist.isEmpty ? 0.0 : done / checklist.length;

    await db.updateTripProgress(uid, tripId!, progress);

    Navigator.pushReplacementNamed(
      context,
      "/home",
      arguments: {
        "purpose": widget.purpose,
        "tripId": tripId,
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.purpose} Checklist"),
        backgroundColor: const Color(0xFF4A00E0),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: checklist.length,
              itemBuilder: (context, index) {
                final item = checklist[index];

                return CheckboxListTile(
                  title: Text(item["name"]),
                  subtitle: Text(item["category"]),
                  value: item["checked"],
                  onChanged: (v) {
                    setState(() => item["checked"] = v ?? false);
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newItemController,
                    decoration: const InputDecoration(hintText: "Add new item"),
                    onSubmitted: _addNewItem,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addNewItem(_newItemController.text),
                ),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A00E0),
              ),
              onPressed: _saveChecklist,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text("Save & Done"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
