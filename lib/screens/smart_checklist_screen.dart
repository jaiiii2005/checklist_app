import 'package:flutter/material.dart';

class SmartChecklistScreen extends StatefulWidget {
  final String purpose;
  final List<String> items;

  const SmartChecklistScreen({
    super.key,
    required this.purpose,
    required this.items, required initialItems,
  });

  @override
  State<SmartChecklistScreen> createState() => _SmartChecklistScreenState();
}

class _SmartChecklistScreenState extends State<SmartChecklistScreen> {
  late List<Map<String, dynamic>> _checklist; // {name, checked}
  final TextEditingController _newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checklist = widget.items
        .map((item) => {"name": item, "checked": false})
        .toList();
  }

  void _addNewItem(String item) {
    if (item.trim().isEmpty) return;
    setState(() {
      _checklist.add({"name": item.trim(), "checked": false});
    });
    _newItemController.clear();
  }

  void _finishChecklist() {
    final selectedItems = _checklist
        .where((item) => item["checked"] == true)
        .map((e) => e["name"].toString())
        .toList();

    int total = _checklist.length;
    int packed = selectedItems.length;
    double progress = total == 0 ? 0.0 : packed / total;

    // ✅ Navigate to Home with results
    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {
        "purpose": widget.purpose,
        "selectedItems": selectedItems,
        "progress": progress,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.purpose} Checklist"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A00E0),
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: _checklist.isEmpty
                  ? const Center(
                child: Text(
                  "No items yet. Add something below!",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _checklist.length,
                itemBuilder: (context, index) {
                  final item = _checklist[index];
                  return CheckboxListTile(
                    activeColor: const Color(0xFF4A00E0),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    title: Text(
                      item["name"],
                      style: TextStyle(
                        fontSize: 16,
                        decoration: item["checked"]
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    value: item["checked"],
                    onChanged: (val) {
                      setState(() {
                        _checklist[index]["checked"] = val ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // ➕ Add new item input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newItemController,
                    decoration: InputDecoration(
                      hintText: "Add new item...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: _addNewItem,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A00E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _addNewItem(_newItemController.text),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ Done Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline,
                    color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A00E0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _finishChecklist,
                label: const Text(
                  "Done",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
