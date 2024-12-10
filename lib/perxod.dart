import 'package:flutter/material.dart';
import 'package:instalife/loginPage1.dart';

class Perexod extends StatefulWidget {
  const Perexod({super.key});

  @override
  State<Perexod> createState() => _PerexodState();
}

class _PerexodState extends State<Perexod> {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Container(
              child: Column(
                children: [
                  Text(
                    "from",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "∞Meta",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
