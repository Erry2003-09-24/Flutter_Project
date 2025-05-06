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

  // Funzione per chiamare l'API di NIST e ottenere il significato del termine
  Future<void> _fetchDefinition(String term) async {
    final url = Uri.parse('https://csrc.nist.gov/glossary/term/$term');
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _definition = data['definition'] ?? 'Definizione non trovata';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Errore nel recupero dei dati. Riprova più tardi.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Errore nella connessione. Controlla la tua connessione internet.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Termini di Sicurezza'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Inserisci un termine di sicurezza',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _fetchDefinition(_controller.text);
                }
              },
              child: Text('Cerca Definizione'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _errorMessage.isNotEmpty
                    ? Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Termine: $_term',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
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
