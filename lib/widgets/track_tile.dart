import 'package:flutter/material.dart';
import '../models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;

  const TrackTile({super.key, required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: track.imageUrl.isNotEmpty
          ? Image.network(
              track.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(Icons.music_note);
              },
            )
          : const Icon(Icons.music_note),
      title: Text(track.name),
      subtitle: Text(track.artistName),
      onTap: onTap,
    );
  }
}
