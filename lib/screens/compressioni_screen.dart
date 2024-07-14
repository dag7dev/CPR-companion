import 'package:flutter/material.dart';
import 'package:cpr/screens/pre_compressioni_screen.dart';
import 'ventilazioni_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import '../app_config.dart';

class CompressioniScreen extends StatefulWidget {
  const CompressioniScreen({super.key});

  @override
  _CompressioniScreenState createState() => _CompressioniScreenState();
}

class _CompressioniScreenState extends State<CompressioniScreen>
    with WidgetsBindingObserver {
  void _stopMetronome() async {
    _isPlaying = false;
    await audioPlayer.stop();
  }

  void loadInsufflazioniPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      insufflazioniOn = prefs.getBool('insufflazioni') ?? false;
    });
  }

  int count = 0;
  bool insufflazioniOn = AppConfig.insufflazioni;
  String buttonText = 'Chiama 112';
  double lastZ = 0.0;
  double previousZ = 0.0;
  AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool isCalling = false; // Variabile per tracciare lo stato della chiamata

  @override
  void initState() {
    super.initState();
    loadInsufflazioniPreference();
    WidgetsBinding.instance.addObserver(this);
    if (AppConfig.debugMetronome) {
      _startMetronome();

      Timer.periodic(const Duration(milliseconds: 574), (Timer timer) {
        if (_isPlaying) {
          incrementCount();
        } else {
          timer.cancel();
        }
      });
    } else {
      _startMetronome();
      accelerometerEvents.listen((AccelerometerEvent event) {
        if ((lastZ - event.z).abs() > 6.0) {
          if (event.z < lastZ) {
            previousZ = lastZ;
          } else if (event.z > previousZ) {
            incrementCount();
            previousZ = event.z;
          }
        }
        lastZ = event.z;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isPlaying = false;
    _stopMetronome();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      audioPlayer.stop();
    } else if (state == AppLifecycleState.resumed && _isPlaying) {
      audioPlayer.resume();
    }
  }

  void _startMetronome() async {
    await audioPlayer.setSource(AssetSource('audio/click.mp3'));
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    _isPlaying = true;
    await audioPlayer.resume();

    // Vibrazione a 104 BPM
    while (_isPlaying) {
      if (await Vibration.hasVibrator() != null) {
        await Vibration.vibrate(duration: 100);
      }
      await Future.delayed(Duration(milliseconds: 574));
    }
  }

  void incrementCount() {
    setState(() {
      count++;
      if (count >= AppConfig.compressionsCount) {
        count = 0;
        _stopMetronome();

        if (insufflazioniOn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VentilazioniScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const PreCompressioniScreen()),
          );
        }
      }
    });
  }

  void _onButtonPressed() {
    setState(() {
      if (!isCalling) {
        buttonText = 'Chiamata in corso...';
        isCalling = true;
        Timer(const Duration(seconds: 3), () {
          setState(() {
            buttonText = 'Chiudi chiamata';
          });
        });
      } else {
        buttonText = 'Chiama 112';
        isCalling = false;
      }
    });
    _stopMetronome(); // Fermare il metronomo prima di cambiare schermata
  }

  void _playCompletionSound() async {
    await audioPlayer.setSource(AssetSource('audio/click2.mp3'));
    await audioPlayer.resume();
  }

  void _vibrateLong() async {
    if (await Vibration.hasVibrator() != null) {
      await Vibration.vibrate(duration: 1000); // vibra per 1000 millisecondi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Compressioni',
                  style: TextStyle(
                      color: AppConfig.textInTitlesColor, fontSize: 20),
                ),
                Text(
                  '$count/30',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.textInTitlesColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: _onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 10),
                ToggleButton(
                  onChanged: (value) {
                    setState(() {
                      insufflazioniOn = !insufflazioniOn;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleButton extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const ToggleButton({Key? key, required this.onChanged}) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late bool insufflazioni = false;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      insufflazioni = prefs.getBool('insufflazioni') ?? false;
    });
  }

  void savePreferences(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('insufflazioni', value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Insufflazioni',
          style: TextStyle(color: AppConfig.textInButtonsColor),
        ),
        Switch(
          value: insufflazioni,
          onChanged: (value) {
            setState(() {
              insufflazioni = value;
              widget.onChanged(insufflazioni);
              savePreferences(insufflazioni); // Aggiungi questa linea
            });
          },
          activeColor: Colors.green,
          inactiveThumbColor: Colors.grey,
        ),
      ],
    );
  }
}
