import 'dart:async';
// import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:http/http.dart' as http;
import 'behind_http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class page_lessonData extends StatefulWidget {
  final String lessonId;
  const page_lessonData({Key? key, required this.lessonId}) : super(key: key);

  @override
  lessond_state createState() => lessond_state();
}

bool hard_op = true;
bool isVisible = false;

FlutterFft flutterFft = FlutterFft();
var subscription;
int count = 0;
String picture = "not_found.jpg";
String chords = "";
String id = "";
String freqS = "";
String freqE = "";

int lcount = 0;
var periodicTimer;

int round = 0;
int room = 0;
int maxroom = 4;
double point = 0.0;

double? frequency;
int? frequency2;
String? note;
String? note2;
int? octave;
bool? isRecording;
var data;

var tem1 = const Color.fromARGB(255, 168, 69, 78);
var tem2 = const Color.fromARGB(255, 168, 69, 78);
var tem3 = const Color.fromARGB(255, 168, 69, 78);
var tem4 = const Color.fromARGB(255, 168, 69, 78);
var tem5 = const Color.fromARGB(255, 168, 69, 78);
var tem6 = const Color.fromARGB(255, 168, 69, 78);
int da = 0;

String? btnStart = "Start";

class lessond_state extends State<page_lessonData> {
  Future _savePoint() async {
    /* Get user_id */
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useid = prefs.getString('useid') ?? '';
    // print("useid :" + useid);

    var url = Uri.parse("${dataURL}point_lesson.php");
    response = http.post(url, body: {
      "user_id": useid,
      "lesson_id": id,
      "lesson_score": point.toString(),
    });
  }

  _timer() async {
    while (!(await flutterFft.checkPermission())) {
      flutterFft.requestPermission();
      // IF DENY QUIT PROGRAM
    }

    await flutterFft.startRecorder();
    print("Recorder started...");
    setState(() => isRecording = flutterFft.getIsRecording);
    periodicTimer = Timer.periodic(
      const Duration(milliseconds: 1000),
      (timer) {
        print("Timer tick: ${timer.tick}");
        setState(() => {
              tem1 = const Color.fromARGB(255, 168, 69, 78),
              tem2 = const Color.fromARGB(255, 168, 69, 78),
              tem3 = const Color.fromARGB(255, 168, 69, 78),
              tem4 = const Color.fromARGB(255, 168, 69, 78),
              tem5 = const Color.fromARGB(255, 168, 69, 78),
              tem6 = const Color.fromARGB(255, 168, 69, 78),
              da++,
              if (!isVisible)
                {
                  /* 4/4 */
                  if (da == 1)
                    {
                      tem1 = const Color.fromARGB(255, 69, 168, 84),
                    }
                  else if (da == 2)
                    {
                      tem2 = const Color.fromARGB(255, 69, 168, 84),
                    }
                  else if (da == 3)
                    {
                      tem3 = const Color.fromARGB(255, 69, 168, 84),
                    }
                  else if (da == 4)
                    {
                      tem4 = const Color.fromARGB(255, 69, 168, 84),
                      da = 0,
                      round++,
                    },
                  if (round == 3)
                    {
                      periodicTimer.cancel(),
                      Timer(Duration(seconds: 1), () {
                        stop();

                        btnStart = "Start";
                        point = 0.0;
                        _dialogPoint(context);
                        room = 0;
                        round = 0;
                        tem1 = const Color.fromARGB(255, 168, 69, 78);
                        tem2 = tem1;
                        tem3 = tem1;
                        tem4 = tem1;
                      }),
                    }
                }
              else
                {
                  /* 6/8 */
                  if (da == 1)
                    {
                      tem1 = const Color.fromARGB(255, 69, 168, 84),
                    }
                  else if (da == 2)
                    {
                      tem2 = const Color.fromARGB(255, 69, 168, 84),
                    }
                  else if (da == 3)
                    {
                      tem3 = const Color.fromARGB(255, 69, 168, 84),
                    }
                  else if (da == 4)
                    {
                      tem4 = const Color.fromARGB(255, 69, 168, 84),
                    }
                  else if (da == 5)
                    {
                      tem5 = const Color.fromARGB(255, 69, 168, 84),
                    }
                  else if (da == 6)
                    {
                      tem6 = const Color.fromARGB(255, 69, 168, 84),
                      da = 0,
                      round++,
                    },
                  if (round == 3)
                    {
                      periodicTimer.cancel(),
                      Timer(Duration(seconds: 1), () {
                        stop();

                        btnStart = "Start";
                        point = 0.0;
                        _dialogPoint(context);
                        room = 0;
                        round = 0;
                        tem1 = const Color.fromARGB(255, 168, 69, 78);
                        tem2 = tem1;
                        tem3 = tem1;
                        tem4 = tem1;
                        tem5 = tem1;
                        tem6 = tem1;
                      }),
                    }
                }
            });
        // if (round == 3) {
        //   periodicTimer.cancel();
        //   Timer(Duration(seconds: 1), () {
        //     stop();

        //     btnStart = "Start";
        //     point = 0.0;
        //     _dialogPoint(context);
        //     room = 0;
        //     round = 0;
        //     tem1 = const Color.fromARGB(255, 168, 69, 78);
        //     tem2 = tem1;
        //     tem3 = tem1;
        //     tem4 = tem1;
        //   });
        // }
      },
    );

    double input;
    subscription = flutterFft.onRecorderStateChanged.listen(
        (data) => {
              print("Changed state, received: $data"),
              setState(
                () => {
                  frequency = data[1] as double,
                  note = data[2] as String,
                  octave = data[5] as int,
                  frequency2 = frequency?.toInt(),
                  /*กติกา
                      round ทำงาน 3 รอบ
                      room นับจำนวนที่ถูกต้อง
                      point คะแนนที่ได้

                      ***แยกตัวแปร ***มาต่อการกำหนดรอบ
                       */
                  input = double.parse(frequency!.toStringAsFixed(2)),
                  //input = 32.70,
                  if (input >= double.parse(freqS) &&
                      input <= double.parse(freqE))
                    {
                      room++,
                    },
                  if (room == maxroom)
                    {
                      periodicTimer.cancel(),
                      stop(),
                      if (maxroom == 4)
                        {
                          point = 1.0,
                        }
                      else
                        {
                          point = 1.5,
                        },
                      _dialogPoint(context),
                      room = 0,
                      round = 0,
                      btnStart = "Start",
                      tem1 = const Color.fromARGB(255, 168, 69, 78),
                      tem2 = tem1,
                      tem3 = tem1,
                      tem4 = tem1,
                      _savePoint(),
                      //stop
                    }
                },
              ),
              flutterFft.setNote = note!,
              flutterFft.setFrequency = frequency!,
              flutterFft.setOctave = octave!,
              print("Octave: ${octave!.toString()}")
            },
        onError: (err) {
          print("Error: $err");
        },
        onDone: () => {print("Isdone")});
  }

  Future _loadLesson() async {
    print(widget.lessonId);
    if (widget.lessonId == "hard") {
      hard_op = true;
    } else {
      hard_op = false;
    }

    var url = Uri.parse("${dataURL}page_lesson.php");
    // var response = await http.post(url);
    var response =
        await http.post(url, body: {"des": widget.lessonId.toString()});
    data = json.decode(response.body);
    if (data != 'non') {
      //show_error("เข้าสู่ระบบสำเร็จ");
      setState(() => {
            id = data[count]['id'],
            chords = data[count]['chords'],
            picture = data[count]['pic'],
            freqS = data[count]['freq_start'],
            freqE = data[count]['freq_end'],
            lcount = int.parse(data[count]['lcount']),
            print(lcount),
          });
    } else {
      print("not");
      //ไม่พบข้อมูล
    }
  }

  void stop() {
    setState(() {
      isRecording = false;
      subscription.cancel();
      flutterFft.stopRecorder();
      print("stop");
    });
  }

  void _next() {
    setState(() => {
          id = data[count]['id'],
          chords = data[count]['chords'],
          picture = data[count]['pic'],
          freqS = data[count]['freq_start'],
          freqE = data[count]['freq_end'],
          lcount = int.parse(data[count]['lcount']),
          print(lcount),
        });
  }

  @override
  void initState() {
    isRecording = flutterFft.getIsRecording;
    // frequency = flutterFft.getFrequency;
    // frequency2 = 0;
    // // test = "";
    // note = flutterFft.getNote;
    // note2 = flutterFft.getNote;
    // octave = flutterFft.getOctave;
    isVisible = false;
    super.initState();
    _loadLesson();
  }

//Step 1.
  String dropdownValue = '4/4';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Lesson Page"),
        ),
        // backgroundColor: Color.fromARGB(207, 255, 255, 255),
        body: WillPopScope(
          onWillPop: () async {
            // ทำสิ่งที่คุณต้องการทำเมื่อผู้ใช้กดปุ่มย้อนกลับ
            // คืนค่า true เพื่ออนุญาตให้ย้อนกลับ, คืนค่า false เพื่อป้องกันการย้อนกลับ
            // สามารถใส่โค้ดที่ต้องการทำในบล็อคนี้ได้
            count = 0;
            return true; // ตัวอย่าง: อนุญาตให้ย้อนกลับ
          },
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 240,
                height: 20,
                // child: Container(width: 70, height: 20, color: Colors.red[100]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      //      SizedBox(
                      // width: 100,
                      // height: 20,
                      // child: Container(
                      // color: Color.fromARGB(255, 78, 157, 111), // สีที่คุณต้องการใส่ให้กับ SizedBox
                      //   ),
                      // ),

                      SizedBox(
                        width: 70,
                        height: 60,
                        child: Container(
                          color:
                              Colors.blue, // สีที่คุณต้องการใส่ให้กับ SizedBox
                          // กำหนดให้เป็น true หรือ false ตามตัวแปร vis
                          child: ElevatedButton(
                            onPressed: () {
                              _showDialog(context);
                            },
                            child: Text(
                              '?',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   width: 75, height: 60,
                  //   // color:Colors.red[100],
                  // ),

                  SizedBox(
                    width: 95,
                    height: 60,
                    child: Container(
                      //color: Color.fromARGB(255, 78, 157,111), // สีที่คุณต้องการใส่ให้กับ SizedBox
                      child: Center(
                        child: Text(
                          chords,
                          style: TextStyle(fontSize: 21),
                        ),
                      ),
                    ),
                  ),

// Step 2.
                  SizedBox(
                    width: 75,
                    height: 50,
                    child: Container(
                      // color: Colors.blue, // สีที่คุณต้องการใส่ให้กับ SizedBox
                      child: Visibility(
                        visible:
                            hard_op, // กำหนดให้เป็น true หรือ false ตามตัวแปร vis
                        child: DropdownButton<String>(
                          // Step 3.
                          value: dropdownValue,
                          // Step 4.
                          items: <String>['4/4', '6/8']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 30),
                              ),
                            );
                          }).toList(),
                          // Step 5.
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;

                              if (dropdownValue == '4/4') {
                                isVisible = false;
                                maxroom = 4;
                              } else {
                                isVisible = true;
                                maxroom = 6;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //<
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        // color: Colors.grey,
                        child: ElevatedButton(
                          // ignore: dead_code
                          onPressed: isRecording!
                              ? null
                              : () {
                                  if (count > 0) {
                                    count--;
                                    //_login();
                                    _next();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(30, 30),
                            //shape: const CircleBorder(),
                            // backgroundColor: result_D,
                          ),
                          child: const Text(
                            "<",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Lesson no. ${count + 1}/$lcount'),
                      SizedBox(
                          width: 230,
                          height: 350,
                          // color: Color.fromARGB(255, 211, 142, 120),
                          child: Image.network(
                              'https://2ef0-27-55-78-210.ngrok-free.app/new_image/$picture')),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        // color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: isRecording!
                              ? null
                              : () {
                                  if (count < lcount - 1) {
                                    count++;
                                    //_login();
                                    _next();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(30, 30),
                            //shape: const CircleBorder(),
                            // backgroundColor: result_D,
                          ),
                          child: const Text(
                            ">",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              /* ------------------------------------------ */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 10, height: 40, color: tem1),
                  Container(
                      width: 40,
                      height: 40,
                      color: const Color.fromARGB(255, 238, 239, 238)),
                  Container(width: 10, height: 40, color: tem2),
                  Container(
                      width: 40,
                      height: 40,
                      color: const Color.fromARGB(255, 238, 239, 238)),
                  Container(width: 10, height: 40, color: tem3),
                  Container(
                      width: 40,
                      height: 40,
                      color: const Color.fromARGB(255, 238, 239, 238)),
                  Container(width: 10, height: 40, color: tem4),

//isVisible
                  Visibility(
                    visible:
                        isVisible, // กำหนดให้เป็น true หรือ false ตามตัวแปร isVisible
                    child: Container(
                      width: 40,
                      height: 40,
                      color: const Color.fromARGB(255, 238, 239, 238),
                    ),
                  ),
                  Visibility(
                    visible:
                        isVisible, // กำหนดให้เป็น true หรือ false ตามตัวแปร isVisible
                    child: Container(
                      width: 10,
                      height: 40,
                      color: tem5,
                    ),
                  ),
                  Visibility(
                    visible:
                        isVisible, // กำหนดให้เป็น true หรือ false ตามตัวแปร isVisible
                    child: Container(
                      width: 40,
                      height: 40,
                      color: const Color.fromARGB(255, 238, 239, 238),
                    ),
                  ),
                  Visibility(
                    visible:
                        isVisible, // กำหนดให้เป็น true หรือ false ตามตัวแปร isVisible
                    child: Container(
                      width: 10,
                      height: 40,
                      color: tem6,
                    ),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text('Freq. ${freqS} - ${freqE}'),
              //   ],
              // ),
              SizedBox(
                width: 240,
                height: 20,
                // child: Container(width: 70, height: 20, color: Colors.red[100]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    color: Colors.grey,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isRecording!) {
                          periodicTimer.cancel();
                          stop();
                          btnStart = "Start";

                          tem1 = const Color.fromARGB(255, 168, 69, 78);
                          tem2 = tem1;
                          tem3 = tem1;
                          tem4 = tem1;
                          // periodicTimer = null;
                          da = 0;
                        } else {
                          _timer();
                          btnStart = "Stop";
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(130, 50),
                        //shape: const CircleBorder(),
                        // backgroundColor: result_D,
                      ),
                      child: Text(
                        '$btnStart',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: Container(
                      // color: Colors.blue, // สีที่คุณต้องการใส่ให้กับ SizedBox
                      child: Visibility(
                        visible:
                            hard_op, // กำหนดให้เป็น true หรือ false ตามตัวแปร vis
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Style",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 240,
                height: 10,
                // color: const Color.fromARGB(255, 168, 69, 78)
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: Container(
                      // color: Colors.blue, // สีที่คุณต้องการใส่ให้กับ SizedBox
                      child: Visibility(
                        visible:
                            hard_op, // กำหนดให้เป็น true หรือ false ตามตัวแปร vis
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Capo",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

void _dialogPoint(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Your Score'),
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              child: Container(
                width: 30, // กำหนดความกว้างของพื้นที่
                height: 25, // กำหนดความสูงของพื้นที่
                child: Center(
                  child: Text(
                    "${point}",
                    style: TextStyle(fontSize: 20), // กำหนดขนาดตัวอักษร
                  ),
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      });
}

void _showDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('?'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Image.asset("assets/testCord.png"),
                    //color: Color.fromARGB(255, 211, 142, 120),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 25,
                        color: const Color.fromARGB(255, 242, 75, 91),
                        alignment: Alignment.center,
                        child: const Text("1"),
                      ),
                      const SizedBox(
                        width: 30, height: 25,
                        //color: const Color.fromARGB(255, 219, 216, 217)
                      ),
                      //Text("Index finger"),
                      const Text(
                        'Index finger',
                        style: TextStyle(height: 0, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 25,
                        color: const Color.fromARGB(255, 49, 249, 129),
                        alignment: Alignment.center,
                        child: const Text("2"),
                      ),
                      const SizedBox(
                        width: 30, height: 25,
                        //color: const Color.fromARGB(255, 219, 216, 217)
                      ),
                      //Text("Index finger"),
                      const Text(
                        'Middle finger',
                        style: TextStyle(height: 0, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 25,
                        color: const Color.fromARGB(255, 3, 107, 242),
                        alignment: Alignment.center,
                        child: const Text("3"),
                      ),
                      const SizedBox(
                        width: 30, height: 25,
                        //color: Color.fromARGB(0, 219, 216, 217)
                      ),
                      //Text("Index finger"),
                      const Text(
                        'Ring finger',
                        style: TextStyle(height: 0, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 25,
                        color: const Color.fromARGB(255, 243, 220, 46),
                        alignment: Alignment.center,
                        child: const Text("4"),
                      ),
                      const SizedBox(
                        width: 30, height: 25,
                        //color: Color.fromARGB(255, 218, 219, 216)
                      ),
                      //Text("Index finger"),
                      const Text(
                        'Little finger',
                        style: TextStyle(height: 0, fontSize: 20),
                      ),
                    ],
                  ),

                  /*  FloatingActionButton.extended(
                    backgroundColor: const Color(0xff03dac6),
                    foregroundColor: Colors.black,
                    onPressed: () {
                      // Respond to button press
                    },
                    icon: Icon(Icons.add),
                    label: Text('EXTENDED'),
                  ), */
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

var response;
var useid;
