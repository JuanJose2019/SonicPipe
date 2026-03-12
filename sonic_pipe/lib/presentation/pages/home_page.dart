import 'package:flutter/material.dart';
import '../../data/datasources/remote/navidrome_controller.dart';
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
      appBar: AppBar(
        title: Text("Songs example", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: FutureBuilder<List<Song>>(
        future: _loadSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No songs found.'));
          }

          final songs = snapshot.data!;

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: songs.length,
            separatorBuilder: (context, _) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              final song = songs[index];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Cover image (si no tienes portada, usa placeholder)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.coverUrl ?? "https://via.placeholder.com/60",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(width: 14),

                  // Title + Artist (si lo tienes)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        if (song.artist != null)
                          Text(
                            song.artist!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 3 dots
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
