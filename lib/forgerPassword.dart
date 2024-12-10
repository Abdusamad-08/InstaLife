import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:instalife/confirmPasswod.dart';
import 'package:http/http.dart' as http;

class ForgetPasword extends StatefulWidget {
  const ForgetPasword({super.key});

  @override
  State<ForgetPasword> createState() => _ForgetPaswordState();
}

class _ForgetPaswordState extends State<ForgetPasword> {
  bool text = false;
  TextEditingController _Email = TextEditingController();

  Future<void> Forgot() async {
    var response = await http.delete(
        Uri.parse("https://instagram-api.softclub.tj/Account/ForgotPassword"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': _Email.text,
        }));
    if (jsonDecode(response.body)['statusCode'] == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConfirmAcoount()));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error!!"),
            content: Text(jsonDecode(response.body)["errors"][0]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Try again!"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
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
                      "Find your account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      text == false
                          ? "Enter your email or username"
                          : "Enter your phone number",
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
                  keyboardType:
                      text == false ? TextInputType.text : TextInputType.number,
                  controller: _Email,
                  decoration: InputDecoration(
                    labelText:
                        text == false ? "Email or username" : "Phone number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "You may receive WhatsApp and SMS notifications fromus for security and login purposes.",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Forgot();
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
                    child: TextButton(
                  onPressed: () {
                    setState(() {
                      text = !text;
                    });
                  },
                  child: text == false
                      ? Text(
                          textAlign: TextAlign.center,
                          "Search by mobile number instead",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        )
                      : Text(
                          textAlign: TextAlign.center,
                          "Search by Email instead",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
