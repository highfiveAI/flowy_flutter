import 'dart:convert';
import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:record3/screens/recording_screen.dart';
import 'package:record3/screens/upload_info.dart';
import 'package:record3/vos/upload_vo.dart';

class InputScreen extends StatefulWidget {
  final String userType;

  InputScreen({required this.userType});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {

  XFile? _selectedFile;
  String _uploadStatus = '파일을 선택하세요';

  List<Map<String, String>> attendees = [];
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  DateTime? _selectedDateTime;
  final TextEditingController _dateTimeController = TextEditingController();


  Future<void> _pickFile() async {
    try {
      final XFile? file = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp']),
          XTypeGroup(label: 'documents', extensions: ['pdf', 'doc', 'docx', 'txt']),
          XTypeGroup(label: 'audio', extensions: ['mp3', 'wav', 'aac']),
          XTypeGroup(label: 'video', extensions: ['mp4', 'mkv', 'avi']),
          XTypeGroup(label: 'archives', extensions: ['zip', 'rar', '7z']),
          XTypeGroup(label: 'code', extensions: ['js', 'dart', 'py', 'java']),
        ],
      );

      if (file != null) {
        setState(() {
          _selectedFile = file;
          _uploadStatus = '파일 선택 완료: ${file.name}';
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = '파일 선택 오류: $e';
      });
    }
  }
  void _navigateToUploadScreen(BuildContext context) {
    if (_selectedFile == null) {
      // 경고창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("파일 없음"),
            content: const Text("파일을 먼저 선택해주세요."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // 창 닫기
                child: const Text("확인"),
              ),
            ],
          );
        },
      );
    } else {
      // 파일이 있을 때만 화면 전환
      final uploadVo = UploadVO(
        subj: _controller1.text,
        infoN: attendees,
        loc: _controller5.text,
        df: _dateTimeController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UploadScreen(
                uploadVo: uploadVo,
                recordFile: _selectedFile,
              ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회의 정보 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            Text(
              '회의 일자 및 시간',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () async {
                // 날짜 선택
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  // 시간 선택
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    final selected = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );

                    setState(() {
                      _selectedDateTime = selected;
                      _dateTimeController.text = _selectedDateTime!.toIso8601String(); // 화면에 표시
                    });
                  }
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateTimeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today), // 달력 아이콘
                  ),
                ),
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
            Row(
              children: [
                // 이름
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: '이름', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 8),
                // 역할
                Expanded(
                  flex: 1,
                  child: RoleSelector(
                    userType: widget.userType,
                    onRoleSelected: (role) {
                      _roleController.text = role;
                    },
                  ),
                ),
                SizedBox(width: 8),
                // 이메일
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: '이메일', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 8),
                // + 버튼
                IconButton(
                  icon: Icon(Icons.add, size: 28),
                  onPressed: () {
                    setState(() {
                      attendees.add({
                        'name': _nameController.text,
                        'role': _roleController.text,
                        'email': _emailController.text,
                      });
                      _nameController.clear();
                      _roleController.clear();
                      _emailController.clear();
                    });
                  },
                ),
              ],
            ),
            ...attendees.map((attendee) {
              int index = attendees.indexOf(attendee);
              return ListTile(
                title: Text('${attendee['name']} - ${attendee['role']}'),
                subtitle: Text(attendee['email']!),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      attendees.removeAt(index);
                    });
                  },
                ),
              );
            }).toList(),
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

            _selectedFile == null
                ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // 버튼 간격 균등 배치
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecordingScreen()),
                            );
                          },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      child: const Text('녹음'),
                      ),
                      ElevatedButton(
                        onPressed: _pickFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      child: const Text('파일올리기'),
                      ),
                    ],
                    ),
                  ),
                )
                : Container(
              padding: const EdgeInsets.all(8.0), // 패딩 추가
              child: Row(
                children: [
                  Expanded(
                    flex: 8,  // 넓이 비율 설정 (8:2)
                    child: Text(
                      '선택한 파일: ${_selectedFile!.name}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,  // 길면 줄임표 처리
                    ),
                  ),
                  Expanded(
                    flex: 2,  // 넓이 비율 설정 (8:2)
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFile = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),    // 모서리 둥글기
                          side: const BorderSide(color: Colors.black26, width: 1),  // 테두리 색과 두께
                        ),
                    ),
                      child: const Text('X'),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _navigateToUploadScreen(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                '다음',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleSelector extends StatefulWidget {
  final String userType;
  final Function(String) onRoleSelected;
  const RoleSelector({Key? key, required this.userType, required this.onRoleSelected}) : super(key: key);

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  late List<String> roles;

  @override
  void initState() {
    super.initState();
    if (widget.userType == 'student') {
      roles = [
        '팀장 / 조장',
        '발표자',
        'PPT 제작자',
        '자료조사 담당',
        '스크립트 작성자',
        '보고서 작성자',
        '리허설 진행자',
        '기타 (직접 입력)',
      ];
    } else {
      roles = [
        '기획자 (PM)',
        '프론트엔드 개발자',
        '백엔드 개발자',
        '디자이너 (UI/UX)',
        '데이터 분석가',
        '마케터',
        '인턴/보조',
        '기타 (직접 입력)',
      ];
    }
  }

  String? selectedRole;
  String customRole = '';

  void _showRolePicker() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        int? tempSelected = roles.indexOf(selectedRole ?? '');
        String tempCustom = customRole;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8,
                    children: List<Widget>.generate(roles.length, (index) {
                      return ChoiceChip(
                        label: Text(roles[index]),
                        selected: tempSelected == index,
                        onSelected: (selected) {
                          setModalState(() {
                            tempSelected = index;
                            if (roles[index] != '기타 (직접 입력)') {
                              tempCustom = '';
                            }
                          });
                        },
                      );
                    }),
                  ),
                  if (tempSelected == roles.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: '직접 입력',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            tempCustom = value;
                          });
                        },
                      ),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (tempSelected != null) {
                          if (tempSelected == roles.length - 1) {
                            selectedRole = tempCustom;
                            customRole = tempCustom;
                          } else {
                            selectedRole = roles[tempSelected!];
                            customRole = '';
                          }
                          widget.onRoleSelected(selectedRole ?? '');
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Text('선택'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showRolePicker,
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(text: selectedRole ?? ''),
          decoration: InputDecoration(
            labelText: '역할',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        ),
      ),
    );
  }
}
