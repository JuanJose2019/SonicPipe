class Album {
  final String id;
  final String name;
  final String coverUrl;

  Album(this.id, this.name, this.coverUrl);
}

class Song {
  final String id;
  final String title;
  final int duration;
  final String streamUrl;

  Song(this.id, this.title, this.duration, this.streamUrl);
}