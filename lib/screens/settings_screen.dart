import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // NOTE: There is no actual notification scheduling logic in this app
  // (would need flutter_local_notifications + platform setup). This
  // switch is kept as a UI placeholder — wire it up only if you actually
  // add that package.
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          const ListTile(
            leading: Icon(Icons.person),
            title: Text(
              "FlashLearn Pro",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Portfolio Version"),
          ),

          const Divider(),

          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable dark theme"),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),

          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            subtitle: const Text("Quiz reminders"),
            value: notifications,
            onChanged: (value) {
              setState(() => notifications = value);
            },
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text("Version"),
            subtitle: Text("1.0.0"),
          ),

          const ListTile(
            leading: Icon(Icons.code),
            title: Text("Developer"),
            subtitle: Text("Humaira"),
          ),

          const ListTile(
            leading: Icon(Icons.storage),
            title: Text("Storage"),
            subtitle: Text("Local Flashcards Database (Hive)"),
          ),
        ],
      ),
    );
  }
}
