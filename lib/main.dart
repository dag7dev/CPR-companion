import 'package:cpr/screens/compressioni_screen.dart';
import 'package:cpr/screens/ventilazioni_screen.dart';
import 'package:cpr/screens/pre_compressioni_screen.dart';
import 'package:cpr/screens/chiama_ambulanza_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable(); // Mantieni il display attivo all'avvio
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable(); // Disattiva wakelock quando l'app va in background
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      WakelockPlus.disable(); // Disattiva quando l'app va in background
    } else if (state == AppLifecycleState.resumed) {
      WakelockPlus.enable(); // Riattiva quando l'app torna in primo piano
    }
  }

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
