import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record3/screens/review_screen.dart';
import 'package:record3/vos/upload_vo.dart';

class UploadScreen extends StatefulWidget {

  final UploadVO uploadVo;
  final XFile? recordFile;
  const UploadScreen({super.key, required this.uploadVo, required this.recordFile});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  XFile? _selectedFile;
  String _uploadStatus = '파일을 선택하세요';


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
  String formatDate(String dateString) {
    try {
      // 문자열을 DateTime 객체로 파싱
      DateTime dateTime = DateTime.parse(dateString);
      // 원하는 형식으로 변환 (예: yyyy년 MM월 dd일 HH:mm)
      return DateFormat('yyyy년 MM월 dd일 HH:mm').format(dateTime);
    } catch (e) {
      // 파싱 실패 시 원래 문자열 반환
      return dateString;
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    final dio = Dio();
    final uri = 'http://10.0.2.2:8000/multipart-test';

    try {
      // 파일을 FormData로 변환
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_selectedFile!.path, filename: _selectedFile!.name),
      });

      // 파일 업로드 요청
      final response = await dio.post(
        uri,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _uploadStatus = '파일 업로드 성공!  ${response.data['message']} (파일명: ${response.data['filename']}) ';
          print(_uploadStatus);
        });
      } else {
        setState(() {
          _uploadStatus = '업로드 실패: ${response.statusCode}';
          print(_uploadStatus);
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = '업로드 중 오류 발생: $e';
        print(_uploadStatus);
      });
    }
  }

  // 각 입력 필드를 위한 컨트롤러
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xF5F8FCFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('회의 정보', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text('회의 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  color: const Color(0xFFE9EEF5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('회의 주제 :', style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(widget.uploadVo.subj, style: TextStyle(color: Colors.black87, fontSize: 15)),
                        const SizedBox(height: 10),
                        Text('회의 일시 :', style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(formatDate(widget.uploadVo.df), style: TextStyle(color: Colors.black87, fontSize: 15)),
                        const SizedBox(height: 10),
                        Text('회의 장소 :', style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(formatDate(widget.uploadVo.loc), style: TextStyle(color: Colors.black87, fontSize: 15)),
                        const SizedBox(height: 10),
                        Text('참석자 정보 :', style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        SingleChildScrollView(
                          child: Text(
                            widget.uploadVo.infoN.map((attendee) => '${attendee['name']} - ${attendee['role']}').join('\n '),
                            style: TextStyle(color: Colors.black87, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('파일 업로드', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  color: const Color(0xFFE9EEF5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.radio_button_checked, color: Colors.blue, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            ' ${widget.recordFile?.name}',
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReviewScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F72DE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              '다음',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
