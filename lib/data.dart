import 'package:flutter/material.dart';
//import 'dart:html';
import 'dart:convert';

import 'package:http/http.dart' as http;

//import 'behind_http.dart';
class data extends StatefulWidget {
  const data({super.key});

  @override
  State<data> createState() => _nameState();
}

var base = "[]";

class _nameState extends State<data> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  void initState() {
    super.initState();
    _login();
  }

  Future _login() async {
    String dataURL =
        "https://ffcb-27-55-94-230.ngrok-free.app/phpserver/test.php"; //change when start new
    var url = Uri.parse(dataURL);
    //var url = Uri.parse(dataURL+"test.php");

    var response = await http
        .post(url, body: {/*"email": email.text, "password": pass.text*/});
    var data = json.decode(response.body);
    base = data.toString();
    print(data);

    if (data != 'non') {
      setState(() => base = data.toString());
       showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('?'),
          content: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                        width: 30, height: 25,
                        //color: const Color.fromARGB(255, 219, 216, 217)
                      ),
                      //Text("Index finger"),
                      Text(
                        'Point :',
                        style: TextStyle(height: 0, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(base),
      ),
    );
  }
}
