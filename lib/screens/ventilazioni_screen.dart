import 'dart:async';
import 'package:flutter/material.dart';
import '../app_config.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class VentilazioniScreen extends StatefulWidget {
  const VentilazioniScreen({Key? key}) : super(key: key);

  @override
  _VentilazioniScreenState createState() => _VentilazioniScreenState();
}

class _VentilazioniScreenState extends State<VentilazioniScreen> {
  int countdown = AppConfig.countdownSeconds;
  late Timer _timer;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startCountdown();
    _startMetronome();
    _vibrateLong();
  }

  void _vibrateLong() async {
    if (await Vibration.hasVibrator() != null) {
      await Vibration.vibrate(duration: 1000);
    }
  }

  void _startMetronome() async {
    await audioPlayer.setSource(AssetSource('audio/click2.mp3'));
    audioPlayer.setReleaseMode(ReleaseMode.release);
    await audioPlayer.resume();
  }

  void _stopMetronome() async {
    await audioPlayer.stop();
  }

  @override
  void dispose() {
    _timer
        .cancel();
    super.dispose();
  }

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        Navigator.pushNamed(context, '/pre_compressioni_screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Insufflazioni',
              style:
                  TextStyle(color: AppConfig.textInTitlesColor, fontSize: 24),
            ),
            Text(
              '00:${'$countdown'.toString().padLeft(2, '0')}',
              style: const TextStyle(
                  fontSize: 48, color: AppConfig.textInTitlesColor),
            ),
            Image.asset(
              'assets/images/ventilazioni.png',
              width: 90,
              height: 50,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // stop timer
                _timer.cancel();
                Navigator.pushNamed(context, '/pre_compressioni_screen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Finito',
                style: TextStyle(color: AppConfig.textInButtonsColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
