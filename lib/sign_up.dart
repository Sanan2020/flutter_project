//import 'dart:html';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/login.dart';
import 'package:http/http.dart' as http;
import 'behind_http.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  signup_state createState() => signup_state();
}

var response;
String? bb;

class signup_state extends State<sign_up> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  Future _signup() async {
    // String dataURL ="https://a56b-27-55-82-74.ngrok-free.app/phpserver/signup.php";//change when start new
    if (email.text.isNotEmpty &&
        pass.text.isNotEmpty &&
        fname.text.isNotEmpty &&
        lname.text.isNotEmpty) {
      var url = Uri.parse("${dataURL}signup.php");
      response = await http.post(url, body: {
        "email": email.text,
        "password": pass.text,
        "fname": fname.text,
        "lname": lname.text
      });

      var data = json.decode(response.body);
      print(data);
      if (data != 'non') {
        bb = data;
        startContinuousUpdates();
      } else {
        show_error("มีอีเมลล์นี้อยู่แล้ว!!");
      }
    } else {
      show_error("กรุณากรอกข้อมูลให้ครบถ้วน!!");
    }
  }

  void show_error(text) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Itim',
            fontSize: 20,
            color: Color.fromARGB(255, 74, 6, 234),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 215, 223),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        duration: const Duration(seconds: 2)));
  }

  var f;
  void startContinuousUpdates() {
    f = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // Simulated data, replace with actual data

      ///_dialogPoint(context);
      //f.cancel();
    });

    _dialogPoint(context);
    f.cancel();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("Sign up Page"),
        ),
        body: WillPopScope(
          onWillPop: () async {
            // ทำสิ่งที่คุณต้องการทำเมื่อผู้ใช้กดปุ่มย้อนกลับ
            // คืนค่า true เพื่ออนุญาตให้ย้อนกลับ, คืนค่า false เพื่อป้องกันการย้อนกลับ
            // สามารถใส่โค้ดที่ต้องการทำในบล็อคนี้ได้

            response.close;
            return true; // ตัวอย่าง: อนุญาตให้ย้อนกลับ
          },
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //////////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: TextField(
                      controller: fname,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: 160,
                    child: TextField(
                      controller: lname,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'LName',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //////
              SizedBox(
                width: 350,
                child: TextField(
                  obscureText: true,
                  controller: pass,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Button1
              ElevatedButton(
                  onPressed: () async {
                    print("Button1 Click");
                    await _signup();
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => practice(),
                      ),
                    );*/
                  },
                  child: const Padding(
                      padding: EdgeInsets.all(20.0), child: Text("Sign up"))),
              //Distance between Button
              const SizedBox(
                height: 10,
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const name(),
                    ),
                  );
                },
                child: const Text(
                  'I already have an account.',
                  textAlign: TextAlign.right,
                ),
              ),
              ////////////////////////////////////////
            ],
          ),
        ),
      );
}

var s;
void _dialogPoint(BuildContext context) {
  s = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    // Simulated data, replace with actual data

    ///_dialogPoint(context);
    Navigator.of(context).pop();
    s.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const name(),
      ),
    );
  });

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          scrollable: true,
          title: Text(''),
          content: Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      // color: app[2].bg,
                      size: 30.0,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'สมัครสามาชิกสำเร็จ',
                      style: TextStyle(height: 0, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
