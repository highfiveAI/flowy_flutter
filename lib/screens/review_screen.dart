import 'package:flutter/material.dart';
import 'package:record3/main.dart';

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F7FB),
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F7FB),
        elevation: 0,
        title: Text('회의 Review', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('회의 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE6ECF2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('회의 주제 :\n회의 일시 :\n참석자 정보 :', style: TextStyle(color: Colors.black54)),
            ),
            SizedBox(height: 24),
            Text('회의 요약', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 120,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE6ECF2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('요약된 회의 내용 출력', style: TextStyle(color: Colors.black45)),
            ),
            SizedBox(height: 24),
            Text('역할 분담', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 80,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE6ECF2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('회의 참석자 역할에 따른 할 일 정보 전달', style: TextStyle(color: Colors.black45)),
            ),
            SizedBox(height: 24),
            Text('회의 피드백', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 80,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE6ECF2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('회의 피드백 정보 제공', style: TextStyle(color: Colors.black45)),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2583D7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('메일 발송', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(color: Color(0xFF2583D7)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('홈화면 이동', style: TextStyle(fontSize: 18, color: Color(0xFF2583D7))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}