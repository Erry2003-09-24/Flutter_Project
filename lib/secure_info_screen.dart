import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Per caricare file da assets
import 'dart:convert'; // Per convertire il JSON in oggetti Dart

// Aggiunto un commento per testare il commit

class SecureInfoScreen extends StatefulWidget {
  @override
  _SecureInfoScreenState createState() => _SecureInfoScreenState();
}

class _SecureInfoScreenState extends State<SecureInfoScreen> {
  late Future<Map<String, dynamic>> _securityInfo;

  @override
  void initState() {
    super.initState();
    // Carica le informazioni di sicurezza durante l'inizializzazione del widget
    _securityInfo = loadSecurityInfo();
  }

  // Funzione per caricare il file JSON da assets
  Future<Map<String, dynamic>> loadSecurityInfo() async {
    try {
      // Carica il contenuto del file JSON dalla cartella 'assets'
      final String response = await rootBundle.loadString(
        'assets/cybersecurity_info.json',
      );
      final data = json.decode(
        response,
      ); // Converte il contenuto JSON in una mappa
      return data;
    } catch (e) {
      // Gestisce gli errori nel caso in cui ci siano problemi nel caricamento del file
      throw Exception('Errore nel caricamento delle informazioni: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info sulla sicurezza informatica'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _securityInfo, // Ascolta la variabile che contiene i dati
          builder: (context, snapshot) {
            // Stato in attesa di caricamento
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            // Stato in caso di errore nel caricamento
            else if (snapshot.hasError) {
              return Center(child: Text('Errore: ${snapshot.error}'));
            }
            // Stato in caso di dati non disponibili
            else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Nessuna informazione disponibile.'));
            }
            // Stato in caso di dati disponibili
            else {
              final data = snapshot.data!;
              final titolo = data['titolo'] ?? 'Titolo non disponibile';
              final testo = data['testo'] ?? 'Descrizione non disponibile';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titolo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(testo),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
