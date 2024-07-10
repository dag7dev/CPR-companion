import 'package:cpr/screens/compressioni_screen.dart';
import 'package:cpr/screens/ventilazioni_screen.dart';
import 'package:cpr/screens/pre_compressioni_screen.dart';
import 'package:cpr/screens/chiama_ambulanza_screen.dart';

import 'screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wear OS App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      initialRoute: '/',
      routes: {
        '/ventilazioni_screen': (context) => const VentilazioniScreen(),
        '/chiama_ambulanza_screen': (context) => const ChiamaAmbulanzaScreen(),
        '/pre_compressioni_screen': (context) => const PreCompressioniScreen(),
        '/compressioni_screen': (context) => const CompressioniScreen(),
      },
    );
  }
}
