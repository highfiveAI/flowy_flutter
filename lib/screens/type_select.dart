import 'package:flutter/material.dart';
import 'package:record3/screens/insert_info.dart'; // InputScreen 경로 맞게 수정

class SelectTypeScreen extends StatefulWidget {
  @override
  _SelectTypeScreenState createState() => _SelectTypeScreenState();
}

class _SelectTypeScreenState extends State<SelectTypeScreen> {
  String? _selectedType;

  void _selectType(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  void _goToNextScreen() {
    if (_selectedType != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputScreen(userType: _selectedType!),
        ),
      );
    }
  }

  Widget _buildCard(String type, Color color) {
    bool isSelected = _selectedType == type;

    return Expanded(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: isSelected
            ? Matrix4.diagonal3Values(1.05, 1.05, 1)
            : Matrix4.identity(),
        child: GestureDetector(
          onTap: () => _selectType(type),
          child: Container(
            height: 150,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? color.withOpacity(0.4) : Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                type == 'student' ? '학생' : '직장인',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('사용자 유형 선택')),
      body: Column(
        children: [
          SizedBox(height: 40),
          Text(
            '당신은 어떤 유형인가요?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCard('student', Colors.blue),
                _buildCard('worker', Colors.green),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: _selectedType != null ? _goToNextScreen : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '다음',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
