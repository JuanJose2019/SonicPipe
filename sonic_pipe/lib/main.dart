import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/playlists_page.dart';
import 'pages/albums_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationState(),
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