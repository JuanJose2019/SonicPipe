import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../../models/music.dart';

class SonicWave {
  final String baseUrl = "https://fzadn4b7337sji7vjplacr2gn4.srv.us/rest/";
  final String user = "Fran";
  final String password = "Putas";
  final String salt = "7f161e";

  SonicWave();

  // ------ MD5 -------
  String md5hash(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);  // ← AQUÍ ESTÁ LA CLAVE
    return digest.toString();
  }

  // ----- TOKEN -----
  String get token => md5hash(password + salt);

  // ============= API: ÁLBUMES =============
  Future<List<Album>> fetchAlbums() async {
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
    final url = Uri.parse(
      "${baseUrl}getSongList2.view?u=$user&t=$token&s=$salt&v=1.16.1&c=flutterapp&f=json&type=all&size=1000",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Error API: ${response.body}");
    }

    final data = json.decode(response.body);

    final songsJson =
        data["subsonic-response"]["songList"]["song"] as List<dynamic>;

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
}