import 'package:flutter/material.dart';
import 'package:instalife/loginPage1.dart';

class Perd extends StatefulWidget {
  const Perd({super.key});

  @override
  State<Perd> createState() => _PerdState();
}

class _PerdState extends State<Perd> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login1()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 350),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("images/image 70 (1).png"),
                fit: BoxFit.cover,
              )),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "You are logged out of your account",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.sentiment_satisfied_alt_rounded,
              size: 50,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
