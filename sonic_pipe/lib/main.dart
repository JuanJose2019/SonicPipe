import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Theme
import 'core/theme/theme_notifier.dart';

// Paginas
import 'presentation/pages/home_page.dart';
import 'presentation/pages/playlists_page.dart';
import 'presentation/pages/albums_page.dart';
import 'presentation/pages/settings_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MusicApp(),
    ),
  );
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.currentTheme,
          home: const NavigationState(),
        );
      },
    );
  }
}

class NavigationState extends StatefulWidget {
  const NavigationState({super.key});

  @override
  State<NavigationState> createState() => _NavigationState();
}

class _NavigationState extends State<NavigationState> {
  int currentPageIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    PlaylistsPage(),
    AlbumsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.amber,
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.queue_music_outlined),
            selectedIcon: Icon(Icons.queue_music),
            label: "Playlists",
          ),
          NavigationDestination(
            icon: Icon(Icons.album_outlined),
            selectedIcon: Icon(Icons.album),
            label: "Albums",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
      body: pages[currentPageIndex],
    );
  }
}