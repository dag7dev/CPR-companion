import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cpr/app_config.dart';

class ChiamaAmbulanzaScreen extends StatefulWidget {
  const ChiamaAmbulanzaScreen({super.key});

  @override
  _ChiamaAmbulanzaScreenState createState() => _ChiamaAmbulanzaScreenState();
}

class _ChiamaAmbulanzaScreenState extends State<ChiamaAmbulanzaScreen> {
  String t = 'Chiama 112';
  int maxLines = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const AutoSizeText(
                  'Posiziona il soggetto in posizione di sicurezza e attendi l\'arrivo dei soccorsi',
                  style: TextStyle(
                    color: AppConfig.textInTitlesColor,
                    height: 0.85,
                    fontSize: 24,
                  ),
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Image.asset(
                  'assets/images/chiama_ambulanza.png',
                  width: 90,
                  height: 50,
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      t = 'Chiamata in corso...';
                      maxLines = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    t,
                    textAlign: TextAlign.center,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
