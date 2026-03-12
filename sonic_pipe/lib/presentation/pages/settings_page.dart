import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/theme_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  Future<void> _loadUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('server_url') ?? "https://fzadn4b7337sji7vjplacr2gn4.srv.us/rest/";
    setState(() {
      _urlController.text = url;
    });
  }

  Future<void> _saveUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_url', _urlController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL del servidor guardada localmente')),
      );
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Apariencia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            const Divider(height: 32),
            const Text("Servidor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: "URL del servidor (API de Navidrome)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveUrl,
                icon: const Icon(Icons.save),
                label: const Text("Guardar URL"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
