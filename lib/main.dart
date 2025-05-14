import 'package:flutter/material.dart';
import 'package:record3/screens/insert_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'WELCOME TO THE APP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 100),
            ClipRRect(
              borderRadius: BorderRadius.circular(50), // 이미지의 모서리 둥글게
              child: Image.asset(
                'assets/icon.jpg', // 이미지 경로
                height: 200, // 이미지 크기 조정
              ),
            ),
            SizedBox(height: 100),
            SizedBox(
              width: 300, // 버튼의 넓이 지정
              child: ElevatedButton(
                onPressed: () {
                  // 버튼 클릭 시 처리할 작업
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InputScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼 배경색
                  padding: EdgeInsets.symmetric(vertical: 10), // 패딩 조정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                  ),
                ),
                child: Text(
                  '시작하기',
                  style: TextStyle(
                    color: Colors.white, // 텍스트 색상 변경
                    fontSize: 18, // 텍스트 크기 조정
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
