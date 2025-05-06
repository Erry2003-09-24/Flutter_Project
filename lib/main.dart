import 'package:flutter/material.dart';
import 'secure_info_screen.dart'; // Assicurati che il file sia nel posto giusto
import 'quiz_screen.dart'; // Aggiungi questo import per il quiz (devi creare questa schermata)
import 'apiScreen.dart'; // Aggiungi questo import per la schermata API

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberSecure',
      home: MyHomePage(), // usa una pagina separata
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'CyberSecure',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Pulsante per visualizzare le informazioni sulla sicurezza
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecureInfoScreen()),
                );
              },
              child: Text('Scopri di più sulla sicurezza informatica'),
            ),
            SizedBox(height: 20),
            // Pulsante per il quiz
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(),
                  ), // Naviga alla schermata del quiz
                );
              },
              icon: Icon(Icons.quiz), // Icona del quiz
              label: Text('Fai il Quiz'), // Etichetta del pulsante
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApiScreen(),
                  ), // Naviga alla schermata API
                );
              },
              child: Text(
                'API Termini di Sicurezza',
              ), // Pulsante per la schermata API
            ),
          ],
        ),
      ),
    );
  }
}
