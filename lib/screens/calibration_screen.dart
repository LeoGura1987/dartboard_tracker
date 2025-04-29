import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/game_settings.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({super.key});

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  List<Offset> points = []; // 校正點列表
  bool _cameraError = false; // 相機錯誤 flag
  late html.VideoElement _videoElement; // 相機元素
  late GameSettings settings; // 🆕 這場比賽的設定

  final List<String> stepTexts = [
    "請點擊設定【圓心】🎯",
    "請點擊設定【12點鐘方向】🕛",
    "請點擊設定【3點鐘方向】🕒",
    "請點擊設定【6點鐘方向】🕕",
    "請點擊設定【9點鐘方向】🕘",
  ];

  @override
  void initState() {
    super.initState();

    _videoElement = html.VideoElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..autoplay = true
      ..muted = true
      ..setAttribute('playsinline', 'true');

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'videoElement',
      (int viewId) => _videoElement,
    );

    html.window.navigator.mediaDevices?.getUserMedia({'video': true}).then(
      (stream) {
        _videoElement.srcObject = stream;
      },
    ).catchError((e) {
      print("無法啟動相機 - $e");
      setState(() {
        _cameraError = true;
      });
    });
  }

  // 取得傳進來的 GameSettings
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    settings = ModalRoute.of(context)!.settings.arguments as GameSettings;
  }

  void _onTapDown(TapDownDetails details) {
    if (points.length < 5) {
      setState(() {
        points.add(details.localPosition);
      });
    }
  }

  void _onCalibrationComplete() {
    Navigator.pushNamed(
      context,
      '/game',
      arguments: {
        'settings': settings,
        'calibrationPoints': points,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定飛鏢靶基準點')),
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: Stack(
          children: [
            if (_cameraError)
              Container(
                color: Colors.black87,
                alignment: Alignment.center,
                child: const Text(
                  '❌ 無法啟動相機\n請檢查瀏覽器權限，或重新整理頁面',
                  style: TextStyle(color: Colors.redAccent, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              )
            else
              HtmlElementView(viewType: 'videoElement'),

            // 畫出已點擊的點
            ...points.map((point) => Positioned(
                  left: point.dx - 5,
                  top: point.dy - 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                )),

            // 顯示提示文字
            if (!_cameraError && points.length < 5)
              Positioned(
                top: 30,
                left: 20,
                right: 20,
                child: Text(
                  stepTexts[points.length],
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),

            // 顯示完成按鈕
            if (!_cameraError && points.length == 5)
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: _onCalibrationComplete,
                  child: const Text("✅ 基準點設定完成，開始射飛鏢！"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
