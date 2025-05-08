import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiScreen extends StatefulWidget {
  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  final TextEditingController _controller = TextEditingController();
  String _term = '';
  String _definition = '';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fetchDefinition(String term) async {
    final url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/${term.trim()}');

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _definition = '';
      _term = term;
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List && data.isNotEmpty) {
          final firstMeaning = data[0]['meanings'][0];
          final definition = firstMeaning['definitions'][0]['definition'];

          setState(() {
            _definition = definition ?? 'Definizione non trovata.';
            _isLoading = false;
          });
        } else {
          setState(() {
            _definition = 'Definizione non trovata.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Errore HTTP: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Errore di connessione: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Glossario di Sicurezza Informatica', style: TextStyle(fontWeight: FontWeight.bold),),),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Inserisci un termine in inglese',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _fetchDefinition(_controller.text);
                }
              },
              child: Text('Cerca'),
            ),
            SizedBox(height: 24),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: TextStyle(color: Colors.red))
            else if (_definition.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Termine: $_term',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Definizione: $_definition'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
