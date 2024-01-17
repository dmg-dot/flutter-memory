import 'dart:math';
import 'dart:ui';

import 'package:anbu_memory/screens/detail_memory_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewMemoryScreen extends StatefulWidget {
  const ViewMemoryScreen({super.key});

  @override
  State<ViewMemoryScreen> createState() => _ViewMemoryScreenState();
}

class _ViewMemoryScreenState extends State<ViewMemoryScreen> {
  num dataCnt = 0;
  var data = [];
  getData() async {
    final db = FirebaseFirestore.instance;
    db.collection("memory").get().then(
      (querySnapshot) {
        setState(() {
          for (var docSnapshot in querySnapshot.docs) {
            data.add(docSnapshot.data());
            dataCnt++;
          }
          print('data: $data');
        });
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  @override
  initState() {
    super.initState();

    getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Memory',
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('새로고침')),
              Text('$dataCnt'),
              for (int i = 0; i < dataCnt; i++)
                MemoryComponent(
                  title: data[i]['title'],
                  content: data[i]['content'],
                  image: data[i]['image'],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemoryComponent extends StatefulWidget {
  const MemoryComponent(
      {super.key,
      required this.title,
      required this.content,
      required this.image});
  final String title;
  final String content;
  final String image;

  @override
  State<MemoryComponent> createState() => _MemoryComponentState();
}

class _MemoryComponentState extends State<MemoryComponent> {
  var imageUrl =
      'https://www.hera.org.nz/wp-content/uploads/20150918_Notice_HERAreportR4-103Error_STRUC.jpg';
  getImage() async {
    print(widget.image);
    final storageRef = FirebaseStorage.instance.ref();
    try {
      imageUrl =
          await storageRef.child("images/${widget.image}.jpg").getDownloadURL();
      print(imageUrl);
      setState(() {});
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      print("Failed with error '${e.code}': ${e.message}");
    }
  }

  // 이미지 가져오기를 제일 먼저로 바꾸기!

  @override
  void initState() {
    super.initState();
    getImage();
    setState(() {});
    print('img::::: $imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    double screenwidthFixed = MediaQuery.of(context).size.width / 375;
    double screenheightFixed = MediaQuery.of(context).size.height / 812;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailMemoryScreen(
                title: widget.title,
                content: widget.content,
                image: imageUrl,
              );
              // component 정보 받아서 반복문, detail도 정보 전송
            },
          ),
        );
      },
      child: Container(
          margin: const EdgeInsets.all(10),
          width: screenwidthFixed * 320,
          height: screenheightFixed * 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: Stack(
            children: [
              SizedBox(
                width: screenwidthFixed * 320,
                height: screenheightFixed * 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                width: screenwidthFixed * 320,
                height: screenheightFixed * 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black.withOpacity(0.4)),
              ),
              Container(
                width: screenwidthFixed * 320,
                height: screenheightFixed * 100,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
