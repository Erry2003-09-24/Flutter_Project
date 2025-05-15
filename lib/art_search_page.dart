import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Artworks',
      home: ArtSearchPage(),
    );
  }
}

class ArtSearchPage extends StatefulWidget {
  @override
  _ArtworksPageState createState() => _ArtworksPageState();
}

class _ArtworksPageState extends State<ArtSearchPage> {
  List artworks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArtworks();
  }

  Future<void> fetchArtworks() async {
    final url = Uri.parse('https://api.artic.edu/api/v1/artworks');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          artworks = jsonData['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Errore: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore nella chiamata API: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Opere d\'Arte')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: artworks.length,
              itemBuilder: (context, index) {
                final artwork = artworks[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artwork['title'] ?? 'Senza titolo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('ID: ${artwork['id'] ?? 'N/A'}'),
                        SizedBox(height: 8),
                        Text(
                          'Publication History: ${artwork['publication_history'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
