import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(CrimeApp());

class CrimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicago Crime Reports',
      home: CrimeSearchPage(),
    );
  }
}

class CrimeSearchPage extends StatefulWidget {
  @override
  _CrimeListPageState createState() => _CrimeListPageState();
}

class _CrimeListPageState extends State<CrimeSearchPage> {
  List<dynamic> crimeData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCrimeData();
  }

  Future<void> fetchCrimeData() async {
    final url = Uri.parse('https://data.cityofchicago.org/resource/ijzp-q8t2.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          crimeData = data;
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
      appBar: AppBar(title: Text('Crime Reports')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: crimeData.length,
              itemBuilder: (context, index) {
                final item = crimeData[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ListTile(
                    title: Text(item['primary_type'] ?? 'Tipo sconosciuto'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['description'] ?? ''),
                        Text('Luogo: ${item['location_description'] ?? 'N/A'}'),
                        Text('Data: ${item['date']?.substring(0, 10) ?? 'N/A'}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
