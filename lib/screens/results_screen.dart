import 'package:flutter/material.dart';
import '../models/dart_player_record.dart';

// 統計結果畫面
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 接收從比賽或練習傳過來的資料
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<DartPlayerRecord> playerRecords =
        args['playerRecords'] as List<DartPlayerRecord>;
    final bool isPracticeMode = args['isPracticeMode'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPracticeMode ? '練習結果 🧪' : '比賽結果 🏆'), // 顯示模式
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 標題：玩家得分
            const Text(
              '📋 玩家得分',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 玩家得分列表
            Expanded(
              child: ListView.builder(
                itemCount: playerRecords.length,
                itemBuilder: (context, index) {
                  final record = playerRecords[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('P${record.playerId}'), // 玩家編號
                      ),
                      title: Text('總分：${record.totalScore} 分'), // 總得分
                      subtitle: Text('輪數：${record.rounds.length} 輪'), // 完成輪數
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 重新開始按鈕
            ElevatedButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: const Text('🔄 重新開始'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false, // 移除舊頁面，回到首頁
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
