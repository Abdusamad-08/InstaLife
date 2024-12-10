import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:instalife/bottomnavigationBar.dart';
import 'package:instalife/confirmPasswod.dart';
import 'package:instalife/forgerPassword.dart';
import 'package:instalife/instalifepage.dart';
import 'package:instalife/register.dart';

class Login1 extends StatefulWidget {
  const Login1({super.key});

  @override
  State<Login1> createState() => _Login1State();
}

class _Login1State extends State<Login1> {
  List lang = [
    Text('English'),
    Text('عربى'),
    Text('العربية'),
    Text('Deutsch'),
    Text('Français'),
    Text('Русский'),
    Text('中文'),
    Text('한국어'),
    Text('��िन्��ी'),
    Text('ελληνικά'),
    Text('日本語'),
    Text('한국어'),
    Text('��िन्��ी'),
    Text('ελληνικά'),
  ];
  TextEditingController _usernameController =
      TextEditingController(text: 'samad.jann');
  TextEditingController _passwordController =
      TextEditingController(text: 'samad801');
  FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool isLoading = false;
  bool ss = false;

  Future<void> LoginMetod() async {
    try {
      var response = await http.post(
          Uri.parse("https://instagram-api.softclub.tj/Account/login"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            "userName": _usernameController.text,
            "password": _passwordController.text,
          }));

      if (jsonDecode(response.body)["statusCode"] == 200) {
        var token = jsonDecode(response.body)["data"];
        await _secureStorage.write(key: "token", value: token);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Bottomnav()));
      } else {
        setState(() {
          isLoading = false;
        });
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        e.toString(),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Scaffold(
                            appBar: AppBar(
                              backgroundColor: Colors.blue,
                              automaticallyImplyLeading: false,
                              centerTitle: true,
                              title: Text(
                                "Language",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255)),
                              ),
                            ),
                            body: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return lasd(index);
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: lang.length),
                            ),
                          );
                        });
                  },
                  child: Text("Enlish(US)"),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/image 70 (1).png"),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _usernameController,
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
                  controller: _passwordController,
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
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 155, vertical: 15)),
                  onPressed: () {
                    LoginMetod();
                    setState(() {
                      isLoading = true;
                    });
                  },
                  child: isLoading == false
                      ? Text(
                          "Log in",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      : CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPasword()));
                    },
                    child: Text("Forget password?")),
                SizedBox(
                  height: 120,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 105, vertical: 15)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrePage()));
                  },
                  child: Text(
                    "Create new account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 87, 0, 168)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "∞Meta",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card lasd(int index) {
    return Card(
      child: ListTile(
        onTap: () {},
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.language_rounded,
              color: Colors.blue,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                textAlign: TextAlign.center,
                lang[index].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
