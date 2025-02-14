import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_project/menu.dart';
//import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_project/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'behind_http.dart';

class name extends StatefulWidget {
  const name({super.key});
  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

// SharedPreferences prefs = await SharedPreferences.getInstance();
  // Future<void> _Shared(BuildContext context) async {
  //    SharedPreferences prefs = await SharedPreferences.getInstance();

  // }

  Future _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    // String dataURL ="https://a56b-27-55-82-74.ngrok-free.app/phpserver/test.php"; //change when start new
    var url = Uri.parse("${dataURL}Login.php");
    var response = await http
        .post(url, body: {"email": email.text, "password": pass.text});
    var data = json.decode(response.body);
    print(data);

    if (data != 'non') {
      await prefs.setString('username', email.text);
      await prefs.setString('password', pass.text);
      await prefs.setString('useid', data['id']);
      /* await prefs.setString('password', pass.text);  //user_id */

      //_dialogPoint(context); //popup success
      //statelogin.stateLogin = false; //set state button login

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const menu(),
        ),
      );
      //startContinuousUpdates();
      show_error("เข้าสู่ระบบสำเร็จ");
    } else {
      show_error("บัญชีไม่ถูกต้อง!!");
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

  @override
  void initState() {
    super.initState();
    // kk = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Guitar Trainer "),
      ),
      body: Center(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                  await _login();
                },
                child: const Padding(
                    padding: EdgeInsets.all(20.0), child: Text("Login"))),
            //Distance between Button
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const sign_up(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign up',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////
            // TextButton(
            //   style: ButtonStyle(
            //     foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => forgot_password(),
            //       ),
            //     );
            //   },
            //   child: Text('Forgot password?'),
            // ),
          ],
        ),
      ),
    );
  }
}
