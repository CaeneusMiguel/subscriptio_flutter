import 'package:flutter/material.dart';

class Prototype extends StatefulWidget {
  const Prototype({super.key});

  @override
  State<Prototype> createState() => _PrototypeState();
}

class _PrototypeState extends State<Prototype> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("Prototipo en construcción",style: TextStyle(fontSize: 18),)),
        ],
      ),
    );
  }
}
