// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';

// import '../models/track.dart';

// class SpotifyService {
//   // Method to establish connection with Spotify
//   static Future<bool> connectToSpotify() async {
//     try {
//       bool result = await SpotifySdk.connectToSpotifyRemote(
//         clientId: dotenv.env['SPOTIFY_CLIENT_ID']!,
//         redirectUrl: dotenv.env['SPOTIFY_REDIRECT_URI']!,
//       );
//       return result;
//     } catch (e) {
//       if (e.toString().contains('spotifyNotInstalled')) {
//         print('Spotify app is not installed. Please install Spotify.');
//         _promptToInstallSpotify();
//       } else {
//         print('Error connecting to Spotify: $e');
//       }
//       return false;
//     }
//   }

//   // Method to prompt user to install Spotify
//   static void _promptToInstallSpotify() {
//     const url = 'https://apps.apple.com/app/spotify-music/id324684580';
//     _launchURL(url);
//   }

//   // Helper method to open a URL
//   static void _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print('Could not launch $url');
//     }
//   }

//   // Method to obtain access token
//   static Future<String> _getAccessToken() async {
//     try {
//       return await SpotifySdk.getAccessToken(
//         clientId: dotenv.env['SPOTIFY_CLIENT_ID']!,
//         redirectUrl: dotenv.env['SPOTIFY_REDIRECT_URI']!,
//         scope: 'user-read-private',
//       );
//     } catch (e) {
//       print('Error obtaining access token: $e');
//       rethrow;
//     }
//   }

//   // Method to search tracks
//   static Future<List<Track>> searchTracks(String query) async {
//     final token = await _getAccessToken();
//     final url = Uri.parse(
//         'https://api.spotify.com/v1/search?q=${Uri.encodeComponent(query)}&type=track&limit=10');
//     final response =
//         await http.get(url, headers: {'Authorization': 'Bearer $token'});

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final tracks = data['tracks']['items'] as List<dynamic>;
//       return tracks.map((item) {
//         return Track(
//           name: item['name'],
//           artistName: item['artists'][0]['name'],
//           imageUrl: item['album']['images'].isNotEmpty
//               ? item['album']['images'][0]['url']
//               : '',
//         );
//       }).toList();
//     } else {
//       print('Failed to fetch tracks. Status code: ${response.statusCode}');
//       throw Exception('Failed to fetch tracks');
//     }
//   }
// }
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/track.dart';

class SpotifyService {
  // Method to obtain access token
  static Future<String> getAccessToken() async {
    try {
      final clientId = dotenv.env['SPOTIFY_CLIENT_ID']!;
      final clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET']!;
      final authString = base64.encode(utf8.encode('$clientId:$clientSecret'));

      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Authorization': 'Basic $authString',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token'];
      } else {
        throw Exception(
            'Failed to fetch access token. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error obtaining access token: $e');
      rethrow;
    }
  }

  // Method to search tracks
  static Future<List<Track>> searchTracks(String query) async {
    final token = await getAccessToken();
    final url = Uri.parse(
        'https://api.spotify.com/v1/search?q=${Uri.encodeComponent(query)}&type=track&limit=10');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['tracks']['items'] as List<dynamic>;
      return tracks.map((item) {
        return Track(
          name: item['name'],
          artistName: item['artists'][0]['name'],
          imageUrl: item['album']['images'].isNotEmpty
              ? item['album']['images'][0]['url']
              : '',
        );
      }).toList();
    } else {
      throw Exception(
          'Failed to fetch tracks. Status code: ${response.statusCode}');
    }
  }
}
