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
                    if (dataCnt == 3) setState(() {});
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
                image: widget.image,
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
                    child: Image.asset(
                      'assets/images/anya.png',
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
                child: const Center(
                  child: Text(
                    '스파이 패밀리 극장판 대개봉 뽀로로 크롱 에디 루피 로디 스파이 패밀리 극장판 대개봉 뽀로로 크롱 에디 루피 로디 스파이 패밀리 극장판 대개봉 뽀로로 크롱 에디 루피 로디 스파이 패밀리 극장판 대개봉 뽀로로 크롱 에디 루피 로디',
                    style: TextStyle(
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
