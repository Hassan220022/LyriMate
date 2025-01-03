import 'package:flutter/material.dart';
import '../services/spotify_service.dart';
import '../widgets/search_bar.dart';
import '../widgets/track_tile.dart';
import '../models/track.dart';
import 'detail_screen.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Track> _results = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// Track the current Dark/Light mode in this screen state
  bool _isDarkMode = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _results = [];
    });

    try {
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please enter a search term.';
        });
        return;
      }

      final tracks = await SpotifyService.searchTracks(query);
      setState(() {
        _results = tracks;
      });

      if (_results.isEmpty) {
        setState(() {
          _errorMessage = 'No results found. Try a different query.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch tracks. Check credentials or network.';
      });
      print('Error during search: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToDetail(Track track) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          title: track.name,
          artist: track.artistName,
          imageUrl: track.imageUrl,
        ),
      ),
    );
  }

  /// Toggles the local `_isDarkMode` value and calls `MyApp.of(context)?.toggleTheme(...)`
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    MyApp.of(context)?.toggleTheme(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Search'),
        actions: [
          IconButton(
            // If in dark mode, show "light mode" icon, otherwise show "dark mode" icon
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onSearch: _search,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : _results.isEmpty
                          ? const Center(
                              child: Text(
                                'No results. Please search for a song or artist.',
                              ),
                            )
                          : ListView.builder(
                              itemCount: _results.length,
                              itemBuilder: (context, index) {
                                final track = _results[index];
                                return TrackTile(
                                  track: track,
                                  onTap: () => _navigateToDetail(track),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
