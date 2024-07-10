import 'package:flutter/material.dart';
import 'package:cpr/app_config.dart';
import 'compressioni_screen.dart';
import 'dart:async';

class PreCompressioniScreen extends StatelessWidget {
  const PreCompressioniScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Inizio\nCompressioni',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  height: 0.85,
                  color: AppConfig.textInTitlesColor),
            ),
            const CountdownWidget(),
            Image.asset(
              'assets/images/compressioni.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Azione quando si preme il bottone "Chiama 112"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Chiama 112',
                style: TextStyle(color: AppConfig.textInButtonsColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key});

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  int countdown = AppConfig.countdownSeconds;

  @override
  void initState() {
    countdown = AppConfig.countdownSeconds;
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        // Naviga alla nuova schermata quando il countdown è completato
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CompressioniScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      // sputalo fuori come timer quindi nel formato xx:xx
      '00:${'$countdown'.toString().padLeft(2, '0')}',
      style: const TextStyle(fontSize: 48, color: AppConfig.textInButtonsColor),
    );
  }
}
