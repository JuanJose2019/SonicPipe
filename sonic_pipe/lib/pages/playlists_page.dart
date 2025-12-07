import 'package:flutter/material.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.queue_music),
          title: Text("My Playlist 1"),
          subtitle: Text("20 songs"),
        ),
        ListTile(
          leading: Icon(Icons.queue_music),
          title: Text("My Playlist 2"),
          subtitle: Text("15 songs"),
        ),
      ],
    );
  }
}
