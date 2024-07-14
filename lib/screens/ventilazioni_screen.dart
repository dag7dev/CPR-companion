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
  String buttonText = 'Finito';
  int countdown = 10;
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

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        _stopMetronome();
        Navigator.pushNamed(context, '/pre_compressioni_screen');
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopMetronome();
    super.dispose();
  }

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
                  'Insufflazioni',
                  style: TextStyle(
                    fontSize: 16,
                    height: 0.85,
                    color: AppConfig.textInTitlesColor,
                  ),
                ),
                CountdownWidget(countdown: countdown),
                Image.asset(
                  'assets/images/ventilazioni.png',
                  width: 90,
                  height: 50,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _timer.cancel();
                    _stopMetronome();
                    Navigator.pushNamed(context, '/pre_compressioni_screen');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    buttonText,
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

class CountdownWidget extends StatelessWidget {
  final int countdown;

  const CountdownWidget({Key? key, required this.countdown}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '00:${'$countdown'.toString().padLeft(2, '0')}',
      style: const TextStyle(fontSize: 40, color: AppConfig.textInButtonsColor),
    );
  }
}
