import 'dart:async';
import 'package:flutter/material.dart';

class CircleScreen extends StatefulWidget {
  const CircleScreen({super.key});

  @override
  _CircleScreenState createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  int dotCount = 1;

  @override
  void initState() {
    super.initState();
    _startDotAnimation();
  }

  void _startDotAnimation() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // 점의 개수를 순환시킴 (1 -> 2 -> 3 -> 1)
        dotCount = dotCount % 3 + 1;
      });
    });
  }

  String get dots => '.' * dotCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          width: 350,
          height: 350,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '분석중입니다$dots',  // 점 개수를 텍스트로 표시
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
