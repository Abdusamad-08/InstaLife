import 'package:flutter/material.dart';
import 'package:instalife/loginPage1.dart';
import 'package:instalife/perxod.dart';

void main() {
  runApp(InstaLife());
}

class InstaLife extends StatefulWidget {
  const InstaLife({super.key});

  @override
  State<InstaLife> createState() => _InstaLifeState();
}

class _InstaLifeState extends State<InstaLife> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login1(),
    );
  }
}
