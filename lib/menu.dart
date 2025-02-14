import 'dart:convert';
//import 'dart:math';
import 'dart:async';

//import 'package:flutter/physics.dart';
import 'package:flutter_project/page_junner.dart';
import 'package:flutter_project/page_search.dart';
import 'package:flutter_project/login.dart';
import 'package:flutter_project/level_lesson.dart';
import 'package:flutter_project/type_practice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'behind_http.dart';
import 'package:flutter/material.dart';

class menu extends StatefulWidget {
  const menu({super.key});

  @override
  menu_state createState() => menu_state();
}

var icons;
var data;
bool stateLogin = true;
String username = "";

class menu_state extends State<menu> {
  Future<void> _Shared(BuildContext context) async {
    icons = Icons.login;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';

    if (username != "") {
      setState(() {
        stateLogin = false;
        icons = Icons.person;
        _profile();
      });
    }
  }

  @override
  void initState() {
    _Shared(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("Menu Page"),
          actions: [
            IconButton(
              icon: Icon(icons),
              tooltip: 'Open shopping cart',
              onPressed: () {
                if (stateLogin == false) {
                  _profile();
                  _dialogProfile(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const name(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        // backgroundColor: Color.fromARGB(207, 255, 255, 255),
        body: Center(
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Button1
              ElevatedButton(
                  onPressed: () {
                    print("Button1 Click");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const page_junner(),
                      ),
                    );
                  },
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(46, 20, 46, 20),
                      child: Text("Tuner"))),
              //Distance between Button
              const SizedBox(
                height: 30,
              ),
              //Button2
              ElevatedButton(
                  onPressed: () {
                    print("Button2 Click");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const page_search(),
                      ),
                    );
                  },
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(26, 20, 26, 20),
                      child: Text("Chord seach"))),
              const SizedBox(
                height: 30,
              ),
              //Button3
              ElevatedButton(
                  onPressed: stateLogin
                      ? null
                      : () {
                          print("Button3 Click");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const level_lesson(),
                            ),
                          );
                        },
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: Text("Lesson"))),
              const SizedBox(
                height: 30,
              ),
              //Button4
              ElevatedButton(
                  onPressed: stateLogin
                      ? null
                      : () {
                          print("Button4 Click");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const type_practice(),
                            ),
                          );
                        },
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: Text("Practice"))),
            ],
          ),
        ),
      );
}

void _dialogProfile(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text('คุณ $fname $lname'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    width: 30, height: 25,
                    //color: const Color.fromARGB(255, 219, 216, 217)
                  ),
                  //Text("Index finger"),
                  Row(
                    children: [
                      Text(
                        'คะแนนบทเรียน : $lesson_score',
                        style: const TextStyle(height: 0, fontSize: 20),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(
                        'คะแนนแบบฝึกหัด : $practice_score',
                        style: const TextStyle(height: 0, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            ElevatedButton(
                child: const Text("Logout"),
                onPressed: () {
                  //Navigator.of(context).pop();
                  _logout();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content:
                            const Text('Are you sure you want to proceed?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              // ถ้ากดปุ่ม Cancel, ปิดกล่องข้อความยืนยัน
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              // ถ้ากดปุ่ม Confirm, ทำงานที่ต้องการแล้วปิดกล่องข้อความยืนยัน
                              // ในที่นี้จะพิมพ์ข้อความ "Confirmed" ลง Console
                              print('Confirmed');
                              //Navigator.of(context).pop();
                              stateLogin = true; //Logout
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const menu(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                })
          ],
        );
      });
}

void _logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(
      'username'); // เมื่อกดปุ่ม ลบค่า username ออกจาก SharedPreferences
}

var fname;
var lname;
var lesson_score;
var practice_score;
Future _profile() async {
  var url = Uri.parse("${dataURL}profile.php");
  //picture ??= "";
  var response = await http.post(url, body: {"email": username});
  var data = json.decode(response.body);
  if (data != 'non') {
    //show_error("เข้าสู่ระบบสำเร็จ");
    fname = data['fname'];
    lname = data['lname'];
    lesson_score = data['lesson_score'] ?? 'N/A';
    practice_score = data['practice_score'] ?? 'N/A';
  } else {
    print("not");
  }
}
