// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_project/page_lessonData.dart';

class level_lesson extends StatefulWidget {
  const level_lesson({super.key});

  @override
  practice_State createState() => practice_State();
}

class practice_State extends State<level_lesson> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Lavel of Chords"),
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
                                const page_lessonData(lessonId: 'easy'),
                          ),
                        );
                      },
                      child: const Padding(
                          padding: EdgeInsets.fromLTRB(42, 20, 42, 20),
                          child: Text("Chord Easy"))),
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
                                page_lessonData(lessonId: 'middle'),
                          ),
                        );
                      },
                      child: const Padding(
                          padding: EdgeInsets.fromLTRB(33, 20, 33, 20),
                          child: Text("Chord Normal"))),
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
                                page_lessonData(lessonId: 'hard'),
                          ),
                        );
                      },
                      child: const Padding(
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                          child: Text("Chord Hard"))),
                  //Distance between Button
                ],
              ),
            ],
          ),
        ),
      );
}
