import 'package:flutter/material.dart';
import 'package:instalife/createaccount.dart';

class ConfirmAcoount extends StatefulWidget {
  const ConfirmAcoount({super.key});

  @override
  State<ConfirmAcoount> createState() => _ConfirmAcoountState();
}

class _ConfirmAcoountState extends State<ConfirmAcoount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirm your account",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "We sent a code to your email. Enter that code to confirm your account",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "Can't reset your password?",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Enter code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAcount()));
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      textAlign: TextAlign.center,
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              SizedBox(
                height: 25,
              ),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Send code again",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
