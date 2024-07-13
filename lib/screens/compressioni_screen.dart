import 'package:flutter/material.dart';
import 'package:cpr/screens/pre_compressioni_screen.dart';
import 'ventilazioni_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_config.dart';

class CompressioniScreen extends StatefulWidget {
  const CompressioniScreen({super.key});

  @override
  _CompressioniScreenState createState() => _CompressioniScreenState();
}

class _CompressioniScreenState extends State<CompressioniScreen> {
  int count = 0;
  bool insufflazioniOn = false;
  String buttonText = 'Chiama 112';

  void incrementCount() {
    setState(() {
      count++;

      if (count >= AppConfig.compressionsCount) {
        count = 0;
        if (insufflazioniOn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VentilazioniScreen()),
          );
        } else {
          Navigator.push(
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
      buttonText = 'Chiamata in corso...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
              20.0), 
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
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: AppConfig.textInButtonsColor),
                  ),
                ),
                const SizedBox(height: 10),
                ToggleButton(
                  onChanged: (value) {
                    setState(() {
                      insufflazioniOn = value;
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
    return ElevatedButton(
      onPressed: () {
        setState(() {
          insufflazioni = !insufflazioni;
          widget.onChanged(insufflazioni);
          savePreferences(insufflazioni);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            insufflazioni ? Colors.green.shade700 : Colors.grey.shade900,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        'Insufflazioni ${insufflazioni ? 'On' : 'Off'}',
        style: const TextStyle(color: AppConfig.textInButtonsColor),
      ),
    );
  }
}
