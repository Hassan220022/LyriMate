// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../services/lyrics_service.dart';

class DetailScreen extends StatefulWidget {
  final String artist;
  final String title;
  final String imageUrl;

  const DetailScreen({
    Key? key,
    required this.artist,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> _lyrics = []; // Holds the lyrics lines
  bool _isLoading = false;
  String? _error;
  Color _topColor = Colors.black;
  Color _bottomColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _fetchLyrics();
    _generatePalette();
  }

  Future<void> _fetchLyrics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Call Lyrics.ovh service
      final result =
          await LyricsService.fetchLyrics(widget.artist, widget.title);

      if (result != null && result.isNotEmpty) {
        setState(() {
          _lyrics = result;
        });
      } else {
        setState(() {
          _error = 'Lyrics not found.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch lyrics.';
      });
      print('Error fetching lyrics: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Optional: Heuristic to detect if the majority of lines are RTL (e.g., Arabic).
  bool _isRtlLanguage(List<String> lines) {
    int rtlCount = 0;
    int totalCount = 0;

    // Define a simple function to check if a line starts with Arabic characters
    bool isLineRtl(String line) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) return false;
      // Check the first character's Unicode
      final firstCodeUnit = trimmed.runes.first;
      // Arabic block is roughly 0x0600 to 0x06FF
      return (firstCodeUnit >= 0x0600 && firstCodeUnit <= 0x06FF);
    }

    for (var line in lines) {
      if (line.trim().isNotEmpty) {
        totalCount++;
        if (isLineRtl(line)) {
          rtlCount++;
        }
      }
    }

    if (totalCount == 0) return false;
    // If the majority of non-empty lines appear to be Arabic, assume RTL
    return rtlCount > (totalCount / 2);
  }

  final Map<String, List<Color>> _gradientCache = {};

  Future<void> _generatePalette() async {
    try {
      if (widget.imageUrl.isNotEmpty) {
        if (_gradientCache.containsKey(widget.imageUrl)) {
          setState(() {
            _topColor = _gradientCache[widget.imageUrl]![0];
            _bottomColor = _gradientCache[widget.imageUrl]![1];
          });
        } else {
          final PaletteGenerator paletteGenerator =
              await PaletteGenerator.fromImageProvider(
            NetworkImage(widget.imageUrl),
          );

          final topColor =
              paletteGenerator.dominantColor?.color ?? Colors.black;
          final bottomColor =
              paletteGenerator.darkMutedColor?.color ?? Colors.black;

          setState(() {
            _topColor = topColor;
            _bottomColor = bottomColor;
          });

          _gradientCache[widget.imageUrl] = [topColor, bottomColor];
        }
      }
    } catch (e) {
      print('Error generating palette: $e');
      setState(() {
        _topColor = const Color(0xFF1DB954);
        _bottomColor = const Color(0xFF191414);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine direction (for all lyrics) if you want to handle Arabic lines:
    final bool useRtl = _isRtlLanguage(_lyrics);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(50.0),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_topColor, _bottomColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: 60.0,
                    bottom: 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: widget.imageUrl.isNotEmpty
                            ? Image.network(
                                widget.imageUrl,
                                height: 200,
                                errorBuilder: (_, __, ___) {
                                  return const Icon(Icons.music_note,
                                      size: 100);
                                },
                              )
                            : const Icon(Icons.music_note, size: 100),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.artist,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SingleChildScrollView(
                              child: Directionality(
                                textDirection: useRtl
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _lyrics
                                      .map(
                                        (line) => Text(
                                          line,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
