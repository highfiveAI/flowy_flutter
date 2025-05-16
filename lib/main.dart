import 'package:flutter/material.dart';
import 'package:record3/screens/type_select.dart';

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
        backgroundColor: Color(0xFFEDF4FC),
        // title: Text('Welcome'),
      ),
      backgroundColor: Color(0xFFEDF4FC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   'WELCOME TO THE APP',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(height: 100),
            ClipRRect(
              borderRadius: BorderRadius.circular(50), // 이미지의 모서리 둥글게
              child: Image.asset(
                'assets/logo.png', // 이미지 경로
                height: 400, // 이미지 크기 조정
              ),
            ),
            // SizedBox(height: 100),
            SizedBox(
              width: 350, // 버튼의 넓이 지정
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectTypeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1F72DE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.5, horizontal: 16),
                  elevation: 0,
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
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}

