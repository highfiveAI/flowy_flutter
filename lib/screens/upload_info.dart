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
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy년 MM월 dd일 HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _uploadFile() async {
    print("start");
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 200),
        receiveTimeout: const Duration(seconds: 200),
      ),
    );
    final uri = 'http://10.0.2.2:8000/api/v1/analyze';

    Navigator.push(context, MaterialPageRoute(builder: (_) => const CircleScreen()));

    try {
      String uploadJson = jsonEncode(widget.uploadVo.toJson());
      print(uploadJson);

      FormData formData = FormData.fromMap({
        'metadata_json': uploadJson,
        'rc_file': await MultipartFile.fromFile(
          widget.recordFile!.path,
          filename: widget.recordFile!.name,
          contentType: DioMediaType('audio', 'wav'),
        ),
      });

      final response = await dio.post(
        uri,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        setState(() {
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
      if (mounted) Navigator.pop(context);
      String serverDetail = '';
      if (e is DioException) {
        if (e.response?.data != null) {
          try {
            final data = e.response?.data;
            if (data is Map<String, dynamic> && data.containsKey('detail')) {
              final detail = data['detail'];
              if (detail is List) {
                serverDetail = detail.map((item) {
                  if (item is Map<String, dynamic>) {
                    return '[${item['loc']?.join(' > ') ?? ''}] ${item['msg'] ?? ''}';
                  }
                  return item.toString();
                }).join('\n');
              } else {
                serverDetail = detail.toString();
              }
            } else if (data is String) {
              final decoded = jsonDecode(data);
              if (decoded is Map<String, dynamic> && decoded.containsKey('detail')) {
                final detail = decoded['detail'];
                if (detail is List) {
                  serverDetail = detail.map((item) {
                    if (item is Map<String, dynamic>) {
                      return '[${item['loc']?.join(' > ') ?? ''}] ${item['msg'] ?? ''}';
                    }
                    return item.toString();
                  }).join('\n');
                } else {
                  serverDetail = detail.toString();
                }
              } else {
                serverDetail = data;
              }
            } else {
              serverDetail = data.toString();
            }
          } catch (_) {
            serverDetail = e.response?.data.toString() ?? '서버에서 에러 메시지를 내려주지 않음';
          }
        } else {
          serverDetail = '서버에서 에러 메시지를 내려주지 않음';
        }
        print('Dio 오류 발생: ${e.toString()}');
        print('서버에서 내려준 에러 detail: $serverDetail');
        if (mounted) {
          setState(() {
            _uploadStatus = '업로드 중 오류 발생:\n$serverDetail';
          });
        }
      }
    }
  }

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
        title: const Text(
          '회의 정보',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                        Text('회의 주제 :',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(widget.uploadVo.subj,
                            style: TextStyle(color: Colors.black87, fontSize: 15)),
                        const SizedBox(height: 10),
                        Text('회의 일시 :',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(formatDate(widget.uploadVo.df),
                            style: TextStyle(color: Colors.black87, fontSize: 15)),
                        const SizedBox(height: 10),
                        Text('회의 장소 :',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(formatDate(widget.uploadVo.loc),
                            style: TextStyle(color: Colors.black87, fontSize: 15)),
                        const SizedBox(height: 10),
                        Text('참석자 정보 :',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        SingleChildScrollView(
                          child: Text(
                            widget.uploadVo.infoN
                                .map((attendee) =>
                            '${attendee['name']} - ${attendee['role']}')
                                .join('\n '),
                            style: TextStyle(color: Colors.black87, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                const Text(
                  '파일 업로드',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 150,
                  color: Colors.black12,
                  child: Center(
                    child: Text(
                      '선택된 파일: ${widget.recordFile?.name}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
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
            onPressed: _uploadFile,
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