import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Account"),
        ),
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text("Theme"),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text("About"),
        ),
      ],
    );
  }
}
