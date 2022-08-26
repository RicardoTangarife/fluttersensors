import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "HOME - PRINCIPAL",
            style: TextStyle(fontWeight: FontWeight.bold),
            textScaleFactor: 1.8,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          _getFloat(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _getFloat() {
    return FloatingActionButton(
      child: const Icon(Icons.add, color: Colors.black),
      backgroundColor: Colors.redAccent.shade100,
      hoverColor: Colors.grey,
      onPressed: () {
        Fluttertoast.showToast(msg: "Este es un mensaje quemado");
      },
    );
  }
}
