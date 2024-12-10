import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instalife/instalifepage.dart';
import 'package:instalife/loginPage1.dart';
import 'package:http/http.dart' as http;

class RegistrePage extends StatefulWidget {
  const RegistrePage({super.key});

  @override
  State<RegistrePage> createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
  bool ssd = false;
  TextEditingController _Email = TextEditingController();
  TextEditingController _Fullname = TextEditingController();
  TextEditingController _Username = TextEditingController();
  TextEditingController _Password = TextEditingController();
  TextEditingController _ConfirmPassword = TextEditingController();

  Future<void> RegisterMetod() async {
    var response = await http.post(
        Uri.parse("https://instagram-api.softclub.tj/Account/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': _Email.text,
          'fullName': _Fullname.text,
          'userName': _Username.text,
          'password': _Password.text,
          'confirmPassword': _ConfirmPassword.text,
        }));
    if (jsonDecode(response.body)["statusCode"] == 200) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login1()));
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

  bool ss = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        child: Image.asset("images/image 70 (1).png"),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset("images/Instagram Logo.png")
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                TextField(
                  controller: _Email,
                  decoration: InputDecoration(
                    labelText: "Phone number or E-mail",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _Fullname,
                  decoration: InputDecoration(
                    labelText: "Full name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _Username,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: ss,
                  controller: _Password,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ss = !ss;
                        });
                      },
                      icon: ss == false
                          ? Icon(Icons.remove_red_eye_outlined)
                          : Icon(Icons.visibility_off),
                      color: Colors.blue,
                    ),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _ConfirmPassword,
                  obscureText: ssd,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ssd = !ssd;
                        });
                      },
                      icon: ssd == false
                          ? Icon(Icons.remove_red_eye_outlined)
                          : Icon(Icons.visibility_off),
                      color: Colors.blue,
                    ),
                    labelText: "ConfirmPassword",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "By signing up, you agree to our Terms , Privacy Policy and Cookies Policy .",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 150, vertical: 15)),
                  onPressed: () {
                    RegisterMetod();
                  },
                  child: Text(
                    "Sing up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have an account?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login1()));
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
