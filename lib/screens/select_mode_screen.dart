import 'package:flutter/material.dart';

class SelectModeScreen extends StatelessWidget {
  const SelectModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('選擇模式')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/select_players');
              },
              child: const Text('比賽模式 🎯'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 練習模式：直接用 null settings + isPracticeMode=true
                Navigator.pushNamed(
                  context,
                  '/calibration',
                  arguments: {
                    'settings': null,
                    'isPracticeMode': true,
                  },
                );
              },
              child: const Text('練習模式 🧪'),
            ),
          ],
        ),
      ),
    );
  }
}
