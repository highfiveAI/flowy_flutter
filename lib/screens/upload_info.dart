import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // 각 입력 필드를 위한 컨트롤러
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('희의 정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 가장자리 여백
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('회의 정보',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),),
            TextField(
              controller: _controller1,
              decoration: InputDecoration(
                labelText: '회의 주제:',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(
                labelText: '회의 일시:',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _controller3,
              maxLines: 6, // 최대 3줄
              decoration: InputDecoration(
                labelText: '참석자 정보:',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 50),
            Text('파일 업로드',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
            Container(
              height: 150,
              color: Colors.black26,
              child: ElevatedButton(onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 버튼 배경색
                    padding: EdgeInsets.symmetric(vertical: 10), // 패딩 조정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                    ),
                  ),
                  child: Text('선택')),
            ),

            ElevatedButton(
              onPressed: () {
                // 버튼 클릭 시 입력된 값 출력
                print('Input 1: ${_controller1.text}');
                print('Input 2: ${_controller2.text}');
                print('Input 3: ${_controller3.text}');
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
