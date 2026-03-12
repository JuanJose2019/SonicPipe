import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/datasources/remote/navidrome_controller.dart';
import '../../data/models/music.dart';

class SongsPage extends StatefulWidget {
  final Album album;

  const SongsPage({super.key, required this.album});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  static const platform = MethodChannel('com.sonicpipe/exoplayer');
  List<Song>? _cachedSongs;
  String? _currentSongTitle;
  bool _isPlaying = false;

  Future<List<Song>> _loadSongs() async {
    if (_cachedSongs != null) return _cachedSongs!;
    final api = SonicWave();
    _cachedSongs = await api.fetchSongs(widget.album.id);
    return _cachedSongs!;
  }

  Future<void> _playSong(Song song) async {
    setState(() {
      _currentSongTitle = song.title;
      _isPlaying = true;
    });

    try {
      if (_cachedSongs != null) {
        final playlist = _cachedSongs!.map((s) => {'path': s.streamUrl}).toList();
        await platform.invokeMethod('setPlaylist', {'playlist': playlist});
      }
      await platform.invokeMethod('play', {'path': song.streamUrl});
    } on PlatformException catch (e) {
      debugPrint("Error play: ${e.message}");
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      await platform.invokeMethod('toggle');
      setState(() {
        _isPlaying = !_isPlaying;
      });
    } on PlatformException catch (e) {
      debugPrint("Error toggle: ${e.message}");
    }
  }

  Future<void> _nextSong() async {
    try {
      await platform.invokeMethod('next');
    } on PlatformException catch (e) {
      debugPrint("Error next: ${e.message}");
    }
  }

  Future<void> _prevSong() async {
    try {
      await platform.invokeMethod('prev');
    } on PlatformException catch (e) {
      debugPrint("Error prev: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.name),
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

          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = songs[index];
                    final minutes = (song.duration ~/ 60).toString();
                    final seconds = (song.duration % 60).toString().padLeft(2, "0");

                    return ListTile(
                      leading: const Icon(Icons.music_note),
                      title: Text(song.title),
                      subtitle: Text("$minutes:$seconds"),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () => _playSong(song),
                      ),
                      onTap: () => _playSong(song),
                    );
                  },
                  childCount: songs.length,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100), // Espacio para el reproductor flotante
              ),
            ],
          );
        },
      ),
      bottomSheet: _currentSongTitle != null ? _buildFloatingPlayer() : null,
    );
  }

  Widget _buildFloatingPlayer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Contenedor flotante centrado/compacto
        children: [
          const Icon(Icons.music_note),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _currentSongTitle ?? "Desconocido",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: _prevSong,
          ),
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlayPause,
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: _nextSong,
          ),
        ],
      ),
    );
  }
}
