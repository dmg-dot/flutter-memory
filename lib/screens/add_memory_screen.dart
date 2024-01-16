import 'dart:io';

import 'package:anbu_memory/screens/view_memory_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  File? imageFile;
  final storage = FirebaseStorage.instance;
  final now = DateTime.now().toIso8601String(); //현재 시간 저장
  String title = '';
  String content = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> uploadImage() async {
    var ref = storage.ref().child('images/$now.jpg'); //참조 생성
    ref.putFile(imageFile!); //참조에 파일 저장
  }

  Future<void> uploadData() async {
    await _firestore
        .collection("memory")
        .doc()
        .set({'title': title, 'content': content, 'image': now});
  }

  var _controllerTitle = TextEditingController(text: '');
  var _controllerContent = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Memory',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: _controllerTitle,
                onChanged: (text) {
                  setState(() {
                    title = text;
                  });
                },
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: '제목을 입력하세요.'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: _controllerContent,
                onChanged: (text) {
                  setState(() {
                    content = text;
                  });
                },
                maxLines: 10,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: '내용을 입력하세요.'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  var picker = ImagePicker();
                  var image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      imageFile = File(image.path);
                      print(imageFile);
                    });
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.add_photo_alternate), Text('사진 추가')],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: (imageFile != null)
                    ? Image.file(imageFile!, fit: BoxFit.cover)
                    : const Text('첨부된 사진이 없어요!')),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              height: 50,
              child: ElevatedButton(
                onPressed: () => {
                  if (imageFile != null && title != '' && content != '')
                    {
                      uploadImage(),
                      uploadData(),
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('추억이 등록됐어요'),
                              content: const Text('추억을 확인해주세요!'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('알겠어요'))
                              ],
                            );
                          }),
                      _controllerTitle.clear(),
                      _controllerContent.clear(),
                      setState(() {
                        title = '';
                        content = '';
                        imageFile = null;
                      }),
                      print(now)
                    }
                  else
                    {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('뭔가 누락됐어요!'),
                              content: const Text('내용을 다시 확인해주세요!'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('알겠어요'))
                              ],
                            );
                          }),
                    }
                },
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '완료',
                        style: TextStyle(fontSize: 16),
                      )
                    ]),
              ),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
