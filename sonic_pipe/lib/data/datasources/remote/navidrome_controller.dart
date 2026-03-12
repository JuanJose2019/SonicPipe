import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/music.dart';

class SonicWave {
  String baseUrl = "https://fzadn4b7337sji7vjplacr2gn4.srv.us/rest/";
  final String user = "Fran";
  final String password = "Putas";
  final String salt = "7f161e";

  SonicWave();

  Future<void> _initBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString('server_url') ?? "https://fzadn4b7337sji7vjplacr2gn4.srv.us/rest/";
    // Make sure it ends with a slash if needed by how it's appended, or just trust the user. Usually just appending is fine.
    if (!baseUrl.endsWith('/')) {
      baseUrl += '/';
    }
  }

  // ------ MD5 -------
  String md5hash(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes); // ← AQUÍ ESTÁ LA CLAVE
    return digest.toString();
  }

  // ----- TOKEN -----
  String get token => md5hash(password + salt);

  // ============= API: ÁLBUMES =============
  Future<List<Album>> fetchAlbums() async {
    await _initBaseUrl();
    final url = Uri.parse(
      "${baseUrl}getAlbumList.view"
      "?u=$user&t=$token&s=$salt&v=1.16.1&c=flutterapp&f=json&type=newest&size=100",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Error API: ${response.body}");
    }

    final data = json.decode(response.body);
    final albumsJson =
        data["subsonic-response"]["albumList"]["album"] as List<dynamic>;

    List<Album> albums = [];

    for (var item in albumsJson) {
      final id = item["id"];
      final name = item["name"];
      final coverId = item["coverArt"];

      final coverUrl =
          "${baseUrl}getCoverArt.view?u=$user&t=$token&s=$salt&v=1.16.1&c=flutterapp&f=json&id=$coverId&size=300&square=true";

      albums.add(Album(id, name, coverUrl));
    }

    return albums;
  }

  // ============= API: CANCIONES DE UN ÁLBUM =============
  Future<List<Song>> fetchSongs(String albumId) async {
    await _initBaseUrl();
    final url = Uri.parse(
      "${baseUrl}getAlbum.view?u=$user&t=$token&s=$salt&v=1.16.1&c=flutterapp&f=json&id=$albumId",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Error API: ${response.body}");
    }

    final data = json.decode(response.body);

    final songsJson =
        data["subsonic-response"]["album"]["song"] as List<dynamic>;

    List<Song> songs = [];

    for (var item in songsJson) {
      final id = item["id"];
      final title = item["title"];
      final duration = item["duration"];

      final streamUrl =
          "${baseUrl}stream.view?u=$user&t=$token&s=$salt&v=1.16.1&c=flutterapp&f=json&id=$id";

      songs.add(Song(id, title, duration, streamUrl));
    }

    return songs;
  }

  // ============= API: TODAS LAS CANCIONES =============
  Future<List<Song>> fetchAllSongs() async {
    await _initBaseUrl();
    final url = Uri.parse(
      "${baseUrl}search3.view"
      "?u=$user&t=$token&s=$salt&v=1.16.1&c=flutterapp&f=json"
      "&query=&songCount=5000&songOffset=0",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Error API: ${response.body}");
    }

    final data = json.decode(response.body);

    final songsJson =
        data["subsonic-response"]["searchResult3"]["song"] as List<dynamic>?;

    if (songsJson == null) {
      return []; // evitar crash
    }

    return songsJson.map((item) {
      final id = item["id"];
      final title = item["title"];
      final duration = item["duration"];
      final artist = item["artist"];
      final coverArt = item["coverArt"];

      final streamUrl =
          "${baseUrl}stream.view?u=$user&t=$token&s=$salt&v=1.16.1&c=flutterapp&f=json&id=$id";

      return Song(id, title, duration, streamUrl, artist: artist, coverUrl: coverArt != null ? "${baseUrl}getCoverArt.view?u=$user&t=$token&s=$salt&v=1.16.1&c=flutterapp&f=json&id=$coverArt&size=300&square=true" : null);
    }).toList();
  }
}

