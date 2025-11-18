import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      widget.isDarkMode ? const Color(0xFF0F1115) : const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧍 Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white24,
                    backgroundImage: AssetImage("assets/profile.png"),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Traveler Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "traveler@email.com",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle("Preferences"),

            // 🌗 Theme Toggle
            _buildSettingTile(
              icon: Icons.dark_mode,
              title: "Dark Mode",
              subtitle: "Switch between light and dark theme",
              trailing: Switch(
                activeColor: const Color(0xFF4A00E0),
                value: widget.isDarkMode,
                onChanged: (value) {
                  widget.onThemeChanged(value);
                  setState(() {});
                },
              ),
            ),

            // 🔔 Notifications
            _buildSettingTile(
              icon: Icons.notifications_active_outlined,
              title: "Notifications",
              subtitle: "Get packing reminders & trip updates",
              trailing: Switch(
                activeColor: const Color(0xFF4A00E0),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle("App Settings"),

            _buildSettingTile(
              icon: Icons.restore,
              title: "Reset Checklist",
              subtitle: "Clear all packed items and start fresh",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Checklist reset successfully!")),
                );
              },
            ),

            _buildSettingTile(
              icon: Icons.feedback_outlined,
              title: "Send Feedback",
              subtitle: "Let us know how we can improve",
              onTap: () {},
            ),

            _buildSettingTile(
              icon: Icons.info_outline,
              title: "About ReadySetGO",
              subtitle: "Version 1.0.0 • Built with Flutter 💙",
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "© 2025 ReadySetGO • All Rights Reserved",
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: widget.isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  // 📋 Reusable Setting Tile
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color(0xFF151922) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4A00E0)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: widget.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      )),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isDarkMode
                            ? Colors.white60
                            : Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
