import 'package:flutter/material.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: Center(child: Text("Album 1")),
        ),
        Card(
          child: Center(child: Text("Album 2")),
        ),
        Card(
          child: Center(child: Text("Album 3")),
        ),
      ],
    );
  }
}
