// lib/services/lyrics_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch lyrics using https://api.lyrics.ovh
class LyricsService {
  /// Returns a list of lyric lines for the given [artist] and [title].
  /// Returns null if lyrics not found or an error occurs.
  static Future<List<String>?> fetchLyrics(String artist, String title) async {
    try {
      // Example: https://api.lyrics.ovh/v1/Adele/Hello
      final url = Uri.parse('https://api.lyrics.ovh/v1/$artist/$title');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Typical success response: { "lyrics": "line1\nline2\n..." }
        if (data.containsKey('lyrics')) {
          final rawLyrics = data['lyrics'] as String;
          // Split by newline into a List<String>
          final lines = rawLyrics.split('\n');
          return lines;
        }
        // Possible response: { "error": "Lyrics not found" }
        else if (data.containsKey('error')) {
          print('Lyrics API error: ${data['error']}');
          return null;
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception fetching lyrics: $e');
    }
    return null;
  }
}
