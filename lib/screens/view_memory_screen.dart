import 'dart:ui';

import 'package:anbu_memory/screens/detail_memory_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewMemoryScreen extends StatefulWidget {
  const ViewMemoryScreen({super.key});

  @override
  State<ViewMemoryScreen> createState() => _ViewMemoryScreenState();
}

class _ViewMemoryScreenState extends State<ViewMemoryScreen> {
  var data = [];
  num dataCnt = 0;

  @override
  initState() {
    super.initState();
    final db = FirebaseFirestore.instance;
    db.collection("memory").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          data.add(docSnapshot.data());
          dataCnt++;
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
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
              Text('$dataCnt'),
              for (num i = 0; i < dataCnt; i++) const MemoryComponent()
            ],
          ),
        ),
      ),
    );
  }
}

class MemoryComponent extends StatelessWidget {
  const MemoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    String title = '제모목';
    String content = '내요요요용';
    String image = 'assets/images/anya.png';
    double screenwidthFixed = MediaQuery.of(context).size.width / 375;
    double screenheightFixed = MediaQuery.of(context).size.height / 812;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailMemoryScreen(
                title: title,
                content: content,
                image: image,
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
