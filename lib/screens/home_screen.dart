import 'package:flutter/material.dart';
import 'chiama_ambulanza_screen.dart';
import 'pre_compressioni_screen.dart';
import 'package:cpr/app_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Respira?',
              style:
                  TextStyle(color: AppConfig.textInTitlesColor, fontSize: 24),
            ),
            Image.asset(
              'assets/images/respira.png',
              width: 90,
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChiamaAmbulanzaScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600),
                  child: const Text('Sì',
                      style: TextStyle(color: AppConfig.textInButtonsColor)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PreCompressioniScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900),
                  child: const Text('No',
                      style: TextStyle(color: AppConfig.textInButtonsColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
