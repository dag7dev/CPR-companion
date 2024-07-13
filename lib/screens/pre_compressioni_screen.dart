import 'package:flutter/material.dart';
import 'package:cpr/app_config.dart';
import 'compressioni_screen.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class PreCompressioniScreen extends StatefulWidget {
  const PreCompressioniScreen({super.key});

  @override
  _PreCompressioniScreenState createState() => _PreCompressioniScreenState();
}

class _PreCompressioniScreenState extends State<PreCompressioniScreen> {
  String buttonText = 'Chiama 112';
  int maxLines = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Inizio\nCompressioni',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 0.85,
                    color: AppConfig.textInTitlesColor,
                  ),
                ),
                const CountdownWidget(),
                Image.asset(
                  'assets/images/compressioni.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      buttonText = 'Chiamata in corso...';
                      maxLines = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppConfig.textInButtonsColor),
                  ),
                ),
              ],
            ),
          ),
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
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    countdown = AppConfig.countdownSeconds;
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

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        _stopMetronome();

        Navigator.pushReplacement(
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
      style: const TextStyle(fontSize: 40, color: AppConfig.textInButtonsColor),
    );
  }
}
