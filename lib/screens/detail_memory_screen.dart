import 'package:flutter/material.dart';

class DetailMemoryScreen extends StatefulWidget {
  const DetailMemoryScreen(
      {super.key,
      required this.title,
      required this.content,
      required this.image});
  final String title;
  final String content;
  final String image;
  @override
  State<DetailMemoryScreen> createState() => _DetailMemoryScreenState();
}

class _DetailMemoryScreenState extends State<DetailMemoryScreen> {
  @override
  Widget build(BuildContext context) {
    double screenwidthFixed = MediaQuery.of(context).size.width / 375;
    double screenheightFixed = MediaQuery.of(context).size.height / 812;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: screenwidthFixed * 320,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Text(
                      widget.content,
                      style: const TextStyle(
                          fontSize: 16, overflow: TextOverflow.visible),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
