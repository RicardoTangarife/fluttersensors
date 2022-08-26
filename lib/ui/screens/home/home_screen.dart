import 'package:flutter/material.dart';
import 'package:fluttersensors/ui/screens/home/pages/home_page.dart';
import 'package:fluttersensors/ui/screens/home/pages/camera_page.dart';
import 'package:fluttersensors/ui/screens/home/pages/microphone_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;
  final items = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      label: 'Camera',
      icon: Icon(Icons.camera_alt_outlined, size: 30),
    ),
    const BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.person, size: 30),
    ),
    const BottomNavigationBarItem(
      label: 'Mic',
      icon: Icon(Icons.mic, size: 30),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("SENSORS APP"),
          backgroundColor: Colors.black,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.output,
              ),
              onPressed: () {
                logout(context);
              },
            ),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        backgroundColor: Colors.redAccent.shade100,
        currentIndex: index,
        items: items,
        onTap: (index) => setState(() => this.index = index),
      ),
      body: _getBody(),
    );
  }

  Future<void> logout(BuildContext context) async {}

  Widget _getBody() {
    Widget body = const HomePage();
    switch (index) {
      case 0:
        body = const CameraPage();
        break;
      case 1:
        body = const HomePage();
        break;
      case 2:
        body = const MicrophonePage();
        break;
      default:
        body = const HomePage();
    }
    return body;
  }
}
