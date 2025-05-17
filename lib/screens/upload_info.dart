
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record3/screens/loading.dart';
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


  Future<void> fetchHelloMessage() async {
    final dio = Dio();

    try {
      // FastAPI 서버 주소를 입력하세요.
      final response = await dio.get('http://10.0.2.2:8000/api/v1/analyze');

      if (response.statusCode == 200) {
        print("hi");
        print('응답: ${response.data}');
      } else {
        print('에러 코드: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print('연결 시간이 초과되었습니다.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('응답 시간이 초과되었습니다.');
      } else {
        print('오류 발생: ${e.message}');
      }
    } catch (e) {
      print('예상치 못한 오류: $e');
    }
  }


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
    // if (_selectedFile == null) return;
    // setState(() {
    //   _selectedFile = widget.recordFile;
    // });
    print("start");
    final dio = Dio((BaseOptions(
      connectTimeout: const Duration(seconds: 200),  // 10초로 설정
      receiveTimeout: const Duration(seconds: 200),  // 데이터 수신 시간 설정
    )));
    final uri = 'http://10.0.2.2:8000/api/v1/analyze';

    Navigator.push(context, MaterialPageRoute(builder: (_) => const CircleScreen()));

    try {
      String uploadJson = jsonEncode(widget.uploadVo.toJson());
      print(uploadJson);
      // 파일을 FormData로 변환
      FormData formData = FormData.fromMap({
        'data': uploadJson,
        'rc_file': await MultipartFile.fromFile(widget.recordFile!.path, filename: widget.recordFile!.name,
      contentType: DioMediaType('audio', 'wav'),  // MIME 타입 지정
        ),
      }
      );
      // 파일 업로드 요청
      final response = await dio.post(
        uri,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      Navigator.pop(context);
      if (response.statusCode == 200) {
        setState(() {
          // _uploadStatus = '파일 업로드 성공!  ${response.data['message']} (파일명: ${response.data['filename']}) ';
          _uploadStatus = '(파일 업로드 성공!  ${response}) ';
          print(_uploadStatus);
        });
        final data = response.data;
        print(data);
        Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => ReviewScreen(data: data)),
        );

      } else {
        setState(() {
          _uploadStatus = '업로드 실패: ${response.statusCode}';
          print(_uploadStatus);
        });
      }
    } catch (e) {
      Navigator.pop(context);
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
            Container(
              color: Colors.black12,
              width: 200,
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('회의 주제: ${widget.uploadVo.subj}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text('회의 일시: ${formatDate(widget.uploadVo.df)}',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text('회의 장소: ${formatDate(widget.uploadVo.loc)}',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text('참석자 정보:\n '
                        '${widget.uploadVo.infoN.map((attendee) => '${attendee['name']} - ${attendee['role']}').join('\n ')}',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: _uploadFile,
              //     () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ReviewScreen()),
              //   );
              // },
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
            Text('파일 업로드',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
            Container(
              height: 150,
              color: Colors.black12,
              child: Center(
                // child: _selectedFile == null
                //     ? ElevatedButton(
                //   onPressed: _pickFile,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue, // 버튼 배경색
                //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 버튼 크기 조정
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                //     ),
                //   ),
                  child: Text(
                    '선택된 파일: ${widget.recordFile?.name}',
                    style: TextStyle(
                      color: Colors.black, // 텍스트 색상 변경
                      fontSize: 18,
                    ),
                  ),
                // )
                //     : Text(
                //   '선택한 파일: ${widget.recordFile?.name}',
                //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                // ),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: _uploadFile,
              //     () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ReviewScreen()),
              //   );
              // },
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
