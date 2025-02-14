// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project/page_practice.dart';
import 'package:flutter_project/shared_login.dart';

class type_practice extends StatefulWidget {
  const type_practice({super.key});

  @override
  practice_State createState() => practice_State();
}

class practice_State extends State<type_practice> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Type of Music"),
        ),
        // backgroundColor: Color.fromARGB(207, 255, 255, 255),
        body: WillPopScope(
          onWillPop: () async {
            // ทำสิ่งที่คุณต้องการทำเมื่อผู้ใช้กดปุ่มย้อนกลับ
            // คืนค่า true เพื่ออนุญาตให้ย้อนกลับ, คืนค่า false เพื่อป้องกันการย้อนกลับ
            // สามารถใส่โค้ดที่ต้องการทำในบล็อคนี้ได้

            return true; // ตัวอย่าง: อนุญาตให้ย้อนกลับ
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Button1
                  ElevatedButton(
                      onPressed: () {
                        print("Button4 Click");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                page_practice(practiceId: 'jazz'),
                          ),
                        );
                      },
                      child: const Padding(
                          padding: EdgeInsets.fromLTRB(42, 20, 42, 20),
                          child: Text("Jazz"))),
                  //Distance between Button
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Button1
                  ElevatedButton(
                      onPressed: () {
                        print("Button4 Click");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                page_practice(practiceId: 'pop'),
                          ),
                        );
                      },
                      child: const Padding(
                          padding: EdgeInsets.fromLTRB(42, 20, 42, 20),
                          child: Text("POP"))),
                  //Distance between Button
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Button1
                  ElevatedButton(
                      onPressed: () {
                        print("Button4 Click");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                page_practice(practiceId: 'rock'),
                          ),
                        );
                      },
                      child: const Padding(
                          padding: EdgeInsets.fromLTRB(36, 20, 36, 20),
                          child: Text("ROCK"))),
                  //Distance between Button
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      );
}
