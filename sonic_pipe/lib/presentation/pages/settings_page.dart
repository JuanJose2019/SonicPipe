import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined),
            title: const Text("Tema claro"),
            trailing: Radio(
              value: "light",
              groupValue: themeNotifier.currentTheme.brightness == Brightness.light ? "light" : "dark",
              onChanged: (_) => themeNotifier.setLightTheme(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text("Tema oscuro"),
            trailing: Radio(
              value: "dark",
              groupValue: themeNotifier.currentTheme.brightness == Brightness.dark ? "dark" : "light",
              onChanged: (_) => themeNotifier.setDarkTheme(),
            ),
          ),
        ],
      ),
    );
  }
}
