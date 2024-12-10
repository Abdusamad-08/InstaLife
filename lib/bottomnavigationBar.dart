import 'package:flutter/material.dart';
import 'package:instalife/Account.dart';
import 'package:instalife/Create.dart';
import 'package:instalife/Reels.dart';
import 'package:instalife/Search.dart';
import 'package:instalife/home.dart';
import 'package:instalife/home2.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  int index = 0;
  List pages = [Home(), Search(), Create(), Reels(), Account()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: index,
        onTap: (value) => setState(() {
          index = value;
        }),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
          BottomNavigationBarItem(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              icon: Icon(Icons.search),
              label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_collection_outlined), label: 'Reels'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp), label: 'Account'),
        ],
      ),
    );
  }
}
