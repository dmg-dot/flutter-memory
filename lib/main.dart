import 'package:anbu_memory/screens/add_memory_screen.dart';
import 'package:anbu_memory/screens/view_memory_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var screens = const [AddMemoryScreen(), ViewMemoryScreen()];
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anbu Memory',
      home: Scaffold(
        body: screens[tab],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: tab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
            BottomNavigationBarItem(
                icon: Icon(Icons.view_agenda), label: 'View'),
          ],
          onTap: (i) {
            setState(() {
              tab = i;
            });
          },
        ),
      ),
    );
  }
}
