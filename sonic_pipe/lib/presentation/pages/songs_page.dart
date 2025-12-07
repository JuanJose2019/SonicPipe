import 'package:flutter/material.dart';
import '../../data/datasources/remote/remote_song_datasource.dart';
import '../../data/models/music.dart';

class SongsPage extends StatelessWidget {
  final Album album;

  const SongsPage({super.key, required this.album});

  Future<List<Song>> _loadSongs() async {
    final api = SonicWave();
    return await api.fetchSongs(album.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
      ),
      body: FutureBuilder<List<Song>>(
        future: _loadSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final songs = snapshot.data ?? [];

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];

              final minutes = (song.duration ~/ 60).toString();
              final seconds =
                  (song.duration % 60).toString().padLeft(2, "0");

              return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(song.title),
                subtitle: Text("$minutes:$seconds"),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    print("Reproducir: ${song.streamUrl}");
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
