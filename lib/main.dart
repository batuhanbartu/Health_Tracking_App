import 'package:flutter/material.dart';
import 'package:health_tracking_app/login_page.dart';
import 'package:health_tracking_app/home_page.dart';
import 'package:health_tracking_app/medicine.dart'; // İlaçlar sayfası
import 'package:health_tracking_app/jab.dart'; // Aşılar sayfası
import 'package:health_tracking_app/serum.dart'; // Serumlar sayfası

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(), // LoginPage için rota tanımı
        '/home': (context) =>
            HomePage(username: ''), // HomePage için rota tanımı
        '/medicine': (context) =>
            MedicinePage(), // İlaçlar sayfası için rota tanımı
        '/jab': (context) => JabPage(), // Aşılar sayfası için rota tanımı
        '/serum': (context) => SerumPage(), // Serumlar sayfası için rota tanımı
      },
    );
  }
}
