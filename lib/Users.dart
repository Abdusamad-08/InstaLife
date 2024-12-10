import 'package:flutter/material.dart';

class User extends StatefulWidget {
  String Userid;
  String name;

  User({super.key, required this.Userid, required this.name});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  bool sam = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "images/3135715.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text("1"),
                        Text("Public"),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text("4"),
                        Text("Podpiski"),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text("1"),
                        Text("folowers"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sam == true
                      ? Container(
                          width: 170,
                          height: 40,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 167, 167, 167),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Follow this",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      : Container(
                          width: 170,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "Follow",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                  Container(
                    width: 170,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 158, 158, 158),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Message",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 255, 254, 254)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DefaultTabController(
              length: 3,
              child: TabBar(
                labelColor: Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 20),
                dividerColor: Colors.grey,
                tabs: [
                  Icon(Icons.apps_rounded),
                  Icon(Icons.video_collection_outlined),
                  Icon(Icons.account_box_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
