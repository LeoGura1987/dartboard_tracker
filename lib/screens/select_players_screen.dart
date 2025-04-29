import 'package:flutter/material.dart';
import '../models/game_settings.dart';

class SelectPlayersScreen extends StatefulWidget {
  const SelectPlayersScreen({super.key});

  @override
  State<SelectPlayersScreen> createState() => _SelectPlayersScreenState();
}

class _SelectPlayersScreenState extends State<SelectPlayersScreen> {
  int playerCount = 2;           // 預設 2 人
  bool separatedBull = false;   // 預設 Fat Bull (統一紅心 50 分)
  String outRule = 'Open';      // 預設 Open 出局規則

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定比賽參數 🎯')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👥 玩家數量設定
            const Text('👥 選擇玩家數量', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: playerCount,
              items: [1, 2, 3, 4]
                  .map((n) => DropdownMenuItem(value: n, child: Text('$n 人')))
                  .toList(),
              onChanged: (value) => setState(() => playerCount = value!),
            ),

            const SizedBox(height: 20),

            // 🎯 紅心模式設定
            const Text('🎯 選擇紅心模式', style: TextStyle(fontSize: 18)),
            RadioListTile<bool>(
              title: const Text('Separated Bull (25分 + 50分)'),
              value: true,
              groupValue: separatedBull,
              onChanged: (v) => setState(() => separatedBull = v!),
            ),
            RadioListTile<bool>(
              title: const Text('Fat Bull (統一50分)'),
              value: false,
              groupValue: separatedBull,
              onChanged: (v) => setState(() => separatedBull = v!),
            ),

            const SizedBox(height: 20),

            // 🏁 出局規則設定
            const Text('🏁 選擇出局規則', style: TextStyle(fontSize: 18)),
            RadioListTile<String>(
              title: const Text('Open Out (無限制)'),
              value: 'Open',
              groupValue: outRule,
              onChanged: (v) => setState(() => outRule = v!),
            ),
            RadioListTile<String>(
              title: const Text('Double Out (雙倍結束)'),
              value: 'Double',
              groupValue: outRule,
              onChanged: (v) => setState(() => outRule = v!),
            ),
            RadioListTile<String>(
              title: const Text('Master Out (雙倍或三倍結束)'),
              value: 'Master',
              groupValue: outRule,
              onChanged: (v) => setState(() => outRule = v!),
            ),

            const SizedBox(height: 30),

            // ✅ 開始校正流程
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final settings = GameSettings(
                    playerCount: playerCount,
                    separatedBull: separatedBull,
                    outRule: outRule,
                  );

                  Navigator.pushNamed(
                    context,
                    '/calibration',
                    arguments: {
                      'settings': settings,
                      'isPracticeMode': false, // 👈 比賽模式
                    },
                  );
                },
                child: const Text('✅ 開始設定基準點'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

