import 'package:flutter/material.dart';

class SmartChecklistScreen extends StatefulWidget {
  final String purpose;
  final List<String> items;

  const SmartChecklistScreen({
    super.key,
    required this.purpose,
    required this.items,
  });

  @override
  State<SmartChecklistScreen> createState() => _SmartChecklistScreenState();
}

class _SmartChecklistScreenState extends State<SmartChecklistScreen> {
  late List<Map<String, dynamic>> _checklist; // item + checked status
  final TextEditingController _newItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checklist = widget.items
        .map((e) => {"name": e, "checked": false})
        .toList(); // preloaded items
  }

  void _addNewItem(String item) {
    if (item.isNotEmpty) {
      setState(() {
        _checklist.add({"name": item, "checked": false});
      });
      _newItemController.clear();
    }
  }

  void _finishChecklist() {
    int total = _checklist.length;
    int packed = _checklist.where((item) => item["checked"]).length;
    double progress = (total == 0) ? 0 : (packed / total);

    Navigator.pushReplacementNamed(
      context,
      '/home',
      arguments: {
        "purpose": widget.purpose,
        "checklist": _checklist,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _checklist.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    activeColor: const Color(0xFF4A00E0),
                    title: Text(
                      _checklist[index]["name"],
                      style: TextStyle(
                        fontSize: 16,
                        decoration: _checklist[index]["checked"]
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    value: _checklist[index]["checked"],
                    onChanged: (val) {
                      setState(() {
                        _checklist[index]["checked"] = val!;
                      });
                    },
                  );
                },
              ),
            ),

            // ➕ Add new item
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newItemController,
                    decoration: InputDecoration(
                      hintText: "Add new item...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
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
            const SizedBox(height: 16),

            // ✅ Done Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A00E0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _finishChecklist,
                child: const Text(
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
