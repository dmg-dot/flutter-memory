import 'package:flutter/material.dart';

class DetailMemoryScreen extends StatefulWidget {
  const DetailMemoryScreen({super.key});

  @override
  State<DetailMemoryScreen> createState() => _DetailMemoryScreenState();
}

class _DetailMemoryScreenState extends State<DetailMemoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제목'),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
