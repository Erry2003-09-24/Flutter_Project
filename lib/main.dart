import 'package:flutter/material.dart';
import 'crime_search_page.dart';
import 'art_search_page.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrimeArt',
      theme: ThemeData(brightness: Brightness.dark),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('CrimeArt', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'L\'app che consente di ricercare crimini e opere d\'arte',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://sky-programmi.kleecks-cdn.com/images/cc/upload/f_webp/v1/logo/logo-n8v3jsrekfjjdleqrypk-1-7ef83',
              width: 210,
              height: 210,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 193, 191, 191),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrimeSearchPage()),
                );
              },
              child: Text('Ricerca Crimini'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 193, 191, 191),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArtSearchPage()),
                );
              },
              child: Text('Ricerca Opere d\'Arte'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 193, 191, 191),
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                Location location = Location();

                bool serviceEnabled;
                PermissionStatus permissionGranted;
                LocationData locationData;

                serviceEnabled = await location.serviceEnabled();
                if (!serviceEnabled) {
                  serviceEnabled = await location.requestService();
                  if (!serviceEnabled) {
                    return;
                  }
                }

                permissionGranted = await location.hasPermission();
                if (permissionGranted == PermissionStatus.denied) {
                  permissionGranted = await location.requestPermission();
                  if (permissionGranted != PermissionStatus.granted) {
                    return;
                  }
                }

                locationData = await location.getLocation();
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text('La tua posizione'),
                        content: Text(
                          'Latitudine: ${locationData.latitude}\n'
                          'Longitudine: ${locationData.longitude}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                );
              },
              child: Text('Individua la posizione'),
            ),
          ],
        ),
      ),
    );
  }
}
