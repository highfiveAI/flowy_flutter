import 'package:flutter/material.dart';
import 'package:record3/screens/upload_info.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회의 정보 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 입력 필드 주변에 여백 추가
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('회의 주제',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            Text('회의 주제를 입력해주세요',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),),
            TextField(
              controller: _controller1,
              decoration: InputDecoration(
                labelText: '✔예:신규 프로젝트 아이디어 회의',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text('회의 일자',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            Text('회의 일자를 선택하세요',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(
                labelText: '예:2023-08-01',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text('회의 시간',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            Text('회의 시간을 선택하세요',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),),
            TextField(
              controller: _controller3,
              decoration: InputDecoration(
                labelText: '예:오후3시~오후4시(1시간)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text('참석자 정보',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            Text('이름, 이메일, 역할을 입력해 주세요',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),),
            TextField(
              controller: _controller4,
              decoration: InputDecoration(
                labelText: '예: 이지은, lee@example.com, 발표자',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text('회의 장소',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            Text('회의 장소를 입력해주세요',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black45,
              ),),
            TextField(
              controller: _controller5,
              decoration: InputDecoration(
                labelText: '예:3층 회의실 A',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 버튼 클릭 시 입력된 값 출력
                print('Input 1: ${_controller1.text}');
                print('Input 2: ${_controller2.text}');
                print('Input 3: ${_controller3.text}');
                print('Input 4: ${_controller4.text}');
                print('Input 5: ${_controller5.text}');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadScreen()),
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
                '다음',
                style: TextStyle(
                  color: Colors.white, // 텍스트 색상 변경
                  fontSize: 18, // 텍스트 크기 조정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
