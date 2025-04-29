// calibration_screen.dart
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
  List<Offset> points = [];
  bool _cameraError = false;
  late html.VideoElement _videoElement;
  late GameSettings? settings;
  late bool isPracticeMode;

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
    ui.platformViewRegistry.registerViewFactory('videoElement', (int viewId) => _videoElement);
    html.window.navigator.mediaDevices?.getUserMedia({'video': true}).then(
      (stream) {
        _videoElement.srcObject = stream;
      },
    ).catchError((e) {
      setState(() {
        _cameraError = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    settings = args['settings'] as GameSettings?;
    isPracticeMode = args['isPracticeMode'] ?? false;
  }

  void _onTapDown(TapDownDetails details) {
    if (points.length < 5) {
      setState(() {
        points.add(details.localPosition);
      });
    }
  }

  void _onCalibrationComplete() {
    Navigator.pushNamed(context, '/game', arguments: {
      'settings': settings,
      'calibrationPoints': points,
      'isPracticeMode': isPracticeMode,
    });
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
