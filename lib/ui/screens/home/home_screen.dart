import 'package:flutter/material.dart';
import 'package:fluttersensors/ui/screens/home/pages/home_page.dart';
import 'package:fluttersensors/ui/screens/home/pages/camera_page.dart';
import 'package:fluttersensors/ui/screens/home/pages/microphone_page.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:login/ui/models/user.model.dart';
//import 'package:login/ui/screens/home/pages/image_screen.dart';
//import 'package:login/ui/screens/login/login_screen.dart';
//import 'package:login/ui/screens/home/pages/record_screen.dart';
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;
  final items = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.camera_alt_outlined, size: 30),
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person, size: 30),
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.mic, size: 30),
    ),
  ];

  /*List<UserModel> contacts = [];
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loogedInUser = UserModel();*/

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
        fixedColor: Colors.redAccent.shade100,
        backgroundColor: Colors.transparent,
        //height: 60,
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
        body = MicrophonePage();
        break;
      default:
        body = const HomePage();
    }
    return body;
  }
}
