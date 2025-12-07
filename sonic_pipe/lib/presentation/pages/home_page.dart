import 'package:flutter/material.dart';
import '../../data/datasources/remote/remote_song_datasource.dart';
import '../../data/models/music.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Song>> _loadSongs() async {
    final api = SonicWave();
    return await api.fetchAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Song>>(
        future: _loadSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No songs found.'));
          } else {
            final songs = snapshot.data!;
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  title: Text(song.title),
                  subtitle: Text('Duration: ${song.duration}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}