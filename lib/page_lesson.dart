import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'behind_http.dart';
import 'package:http/http.dart' as http;

class page_lesson extends StatefulWidget {
  const page_lesson({super.key});

  @override
  lesson_state createState() => lesson_state();
}

FlutterFft flutterFft = FlutterFft();
var subscription;

class Meeting {
  Meeting({
    required this.id,
    required this.bg,
    required this.free,
  });
  String id;
  dynamic bg;
  int free;
}

String? btnStart;
Completer<void> _completer = Completer<void>();
List imgList = [
  ["C7", Image.asset('Image/_cordC7.png'), 32.80, 32.86],
  ["Dsus4", Image.asset('Image/_cordDsus4.png'), 73.08, 73.69],
  ["Asus4", Image.asset('Image/_cordAsus4.png'), 18.28, 18.33],
  ["Dsus2", Image.asset('Image/_cordDsus2.png'), 36.31, 36.65],
  // Image.asset('Images/S2.png'),
];

List imgList2 = [
  ["C7", Image.asset('Image/_cordC7.png'), 32.80, 32.86],
  ["Dsus4", Image.asset('Image/_cordDsus4.png'), 73.08, 73.69],
  ["Asus4", Image.asset('Image/_cordAsus4.png'), 18.28, 18.33],
  ["Dsus2", Image.asset('Image/_cordDsus2.png'), 36.31, 36.65],
  // Image.asset('Images/S2.png'),
];
List userList = [{}, {}, {}];

var intList = [1, 2, 3, 4];
var io = [10][10];

int point = 0;
final List<Meeting> app = [];
bool? _isDisable = false;
bool? allow = true;
String? test;

String? chords;
String? picture;

class lesson_state extends State<page_lesson> {
  Future _pic() async {
    // String dataURL ="https://a56b-27-55-82-74.ngrok-free.app/phpserver/test.php"; //change when start new
    var url = Uri.parse("${dataURL}lesson.php");
    //picture ??= "";
    var response = await http.post(url, body: {"id": nextCord.toString()});
    var data = json.decode(response.body);
    if (data != 'non') {
      //show_error("เข้าสู่ระบบสำเร็จ");
      setState(() => {
            chords = data['chords'],
            picture = data['pic'],
            print(picture),
          });
    } else {
      print("not");
      //ไม่พบข้อมูล
    }
  }

  double? frequency;
  int? frequency2;
  String? note;
  String? note2;
  int? octave;
  bool? isRecording;

  var Line_1;
  var Line_2;
  var Line_3;
  var Line_4;

  int nextCord = 58;
  var ImgCount = imgList.length;
  bool? state;
  var periodicTimer;
  var time;
  int? c;
  int rount = 0;
  _initialize() async {
    print("Starting recorder...");
    // if (allow! == true) {
    periodicTimer = Timer.periodic(
      const Duration(milliseconds: 490),
      (timer) {
        // Update user about remaining time
        print("vvvvv${timer.tick}");
        setState(() => {
              time = timer.tick,
              app[0].bg = Colors.black,
              app[1].bg = Colors.black,
              app[2].bg = Colors.black,
              app[3].bg = Colors.black,

              app[rount].bg = Colors.red,
              // if (timer.tick > 3) {
              if (rount >= 3)
                {
                  // timer.cancel();
                  rount = 0,
                }
              else
                {
                  rount++,
                }
            });
        /* if (timer.tick % 2 == 0) {
          app[0].bg = Colors.black;
        } else {
          app[0].bg = Colors.red;
        }*/
      },
    );
    if (state == true) {
      time.cancel();
    }

    //periodicTimer.tick;
    btnStart = "Stop";
    Meeting l1 = Meeting(id: "258", bg: Colors.black, free: 8);
    Meeting l2 = Meeting(id: "258", bg: Colors.black, free: 8);
    Meeting l3 = Meeting(id: "258", bg: Colors.black, free: 8);
    Meeting l4 = Meeting(id: "258", bg: Colors.black, free: 8);
    app.add(l1);
    app.add(l2);
    app.add(l3);
    app.add(l4);
    // userList.add("258", Image.asset('Image/_cordC7.png'), 8);
    //userList.add();
    //userList.add(895);
    // print("Before");
    // bool hasPermission = await flutterFft.checkPermission();
    // print("After: " + hasPermission.toString());

    // Keep asking for mic permission until accepted
    while (!(await flutterFft.checkPermission())) {
      flutterFft.requestPermission();
      // IF DENY QUIT PROGRAM
    }

    // await flutterFft.checkPermissions();
    await flutterFft.startRecorder();
    print("Recorder started...");
    setState(() => isRecording = flutterFft.getIsRecording);

    Line_1 = Colors.black;
    Line_2 = Colors.black;
    Line_3 = Colors.black;
    Line_4 = Colors.black;
    point = 0;

    subscription = flutterFft.onRecorderStateChanged.listen(
        (data) => {
              print("Changed state, received: $data"),
              setState(
                () => {
                  frequency = data[1] as double,
                  note = data[2] as String,
                  octave = data[5] as int,
                  frequency2 = frequency?.toInt(),
                  test = frequency!.toStringAsFixed(2),
                  //  v = frequency!.toStringAsFixed(2),
                  //  inDouble = double.parse(v),
                  //_textEditingController.text = note.toString(),
                  // if (frequency! >= 32.56 && frequency! <= 32.86) //C7

                  if (rount < 3)
                    {
                      if (frequency! >= nextCord && frequency! <= nextCord)
                        {
                          // app[rount].bg = Colors.green,
                          point++,
                        },
                      if (point == 4)
                        {
                          _dialogPoint(context),
                          point = 0,
                          //stop
                          isRecording = false,
                          flutterFft.stopRecorder(),
                          super.dispose(),
                        }
                    }
                  else
                    {
                      point = 0,
                      // stop(),

                      /*if (app[0].bg == Colors.green &&
                          app[1].bg == Colors.green &&
                          app[2].bg == Colors.green &&
                          app[3].bg == Colors.green)
                        {
                          point = point + 1,
                          _dialogPoint(context),
                          if (isRecording!)
                            {
                              stop(),
                            }
                          //setState(() => isRecording = flutterFft.getIsRecording),
                          // _initialize(),
                        }
                      else
                        {
                          //_dialogPoint(context),
                        }*/
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
    // }
  }

  void _Start() {
    _initialize();
    super.initState();
  }

  @override
  void initState() {
    //--
    isRecording = flutterFft.getIsRecording;
    frequency = flutterFft.getFrequency;
    frequency2 = 0;
    test = "";
    note = flutterFft.getNote;
    note2 = flutterFft.getNote;
    octave = flutterFft.getOctave;

    picture = 'not_found.jpg';
    super.initState();
    _pic();
    _initialize();
    //isRecording = false;//++
  }

  /* @override
  void dispose() {
    super.dispose();
     stop();
  }*/

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
            if (isRecording!) {
              stop();
            }
            return true; // ตัวอย่าง: อนุญาตให้ย้อนกลับ
          },
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

                        //  color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: () {
                            _showDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(30, 40),
                            //shape: const CircleBorder(),
                            // backgroundColor: result_D,
                          ),
                          child: const Text(
                            "?",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    width: 90, height: 60,
                    //color: Colors.red[100]
                  ),

                  //  Column(children: [Text("b")],),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //  color: Colors.grey,
                    child: Text(
                      '$chords',
                      style: const TextStyle(height: 0, fontSize: 25),
                    ),
                    //color: Colors.red,
                  ),
                  const SizedBox(
                    width: 90, height: 60,
                    //color: Colors.red[100]
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        //  color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(70, 50),
                            //shape: const CircleBorder(),
                            // backgroundColor: result_D,
                          ),
                          child: const Text(
                            "4/4",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
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
                        //  color: Colors.grey,
                        child: ElevatedButton(
                          // ignore: dead_code
                          onPressed: isRecording!
                              ? null
                              : () {
                                  if (nextCord > 0) {
                                    setState(() => nextCord--);
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
                      //  Container(width:100, imgList[0]),

                      SizedBox(
                          width: 230,
                          height: 350,
                          child: Image.network(
                              'https://d635-27-55-74-32.ngrok-free.app/new_image/$picture')),

                      /* Container(
                        child: Image.asset("assets/testCord2.png"),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        color: Color.fromARGB(255, 211, 142, 120),
                      ),*/
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //  color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: isRecording!
                              ? null
                              : () {
                                  // _initialize();
                                  //setState(() => super.dispose());
                                  //point = 0;
                                  // 2<3
                                 // if (nextCord < ImgCount - 1) {
                                    setState(() => nextCord++);
                                    _pic();
                                  //}
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  const SizedBox(
                    width: 20, height: 5,
                    //color: Colors.red[100]
                  ),
                  Icon(
                    Icons.arrow_downward,
                    color: app[0].bg,
                    size: 30.0,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_downward,
                    color: app[1].bg,
                    size: 30.0,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: app[2].bg,
                    size: 30.0,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_downward,
                    color: app[3].bg,
                    size: 30.0,
                  ),
                ],
              ),
              const SizedBox(
                width: 240,
                height: 10,
                // color: const Color.fromARGB(255, 168, 69, 78)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(width: 70, height: 40, color: Colors.red[100]),
                  Row(
                    children: [
                      Text(
                        '$test',
                        style: const TextStyle(height: 0, fontSize: 25),
                      ),
                    ],
                  ),
                  // Container(width: 70, height: 40, color: Colors.red[100]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$point',
                    style: const TextStyle(height: 0, fontSize: 25),
                  ),
                ],
              ),
              const SizedBox(
                width: 240,
                height: 10,
                // color: const Color.fromARGB(255, 168, 69, 78)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //  color: Colors.grey,
                    child: ElevatedButton(
                      onPressed: () {
                        // _initialize();
                        // setState(() => _initialize());
                        //initState();
                        point = 0;
                        if (isRecording!) {
                          stop();
                          btnStart = "Start";
                        } else {
                          setState(() {
                            //isRecording = false;
                            // subscription.start();
                            //flutterFft.startRecorder();
                            //super.initState();

                            _initialize();
                            // _Start();
                            btnStart = "Stop";
                          });
                        }
                        /*isRecording = false;
                        subscription.cancel();
                        flutterFft.stopRecorder();*/
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
                ],
              ),
              const SizedBox(
                width: 240,
                height: 10,
                // color: const Color.fromARGB(255, 168, 69, 78)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //  color: Colors.grey,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(130, 50),
                        //shape: const CircleBorder(),
                        // backgroundColor: result_D,
                      ),
                      child: const Text(
                        "Style",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 70,
                    height: 10,
                    //color: Color.fromARGB(255, 132, 34, 43)
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //  color: Colors.grey,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(130, 50),
                        //shape: const CircleBorder(),
                        // backgroundColor: result_D,
                      ),
                      child: const Text(
                        "Capo",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
              /*  Center(
                  child: Container(width: 500, height: 350, child: imgList[0]),
                )*/
            ],
          ),
        ),
      );

  void stop() {
    // setState(() {
    //  subscription.cancel();
    //  time.cancel();
    //periodicTimer = 0;
    //   allow = false;

    // state = true;
    isRecording = false;
    flutterFft.stopRecorder();
    super.dispose();
    print("stop");
    // });
    /*setState(() {
      super.dispose();
      flutterFft.stopRecorder();
      print("stop");
    });*/
    //subscription.
  }
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

void _dialogPoint(BuildContext context) {
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
                  Row(
                    children: [
                      const SizedBox(
                        width: 30, height: 25,
                        //color: const Color.fromARGB(255, 219, 216, 217)
                      ),
                      //Text("Index finger"),
                      Icon(
                        Icons.star,
                        color: app[0].bg,
                        size: 30.0,
                      ),
                      Icon(
                        Icons.star,
                        color: app[0].bg,
                        size: 30.0,
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
                })
          ],
        );
      });
}

void _timer() {
  Timer(const Duration(seconds: 2), () {
    print("test");
  });
}

void startContinuousUpdates() {
  var f = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    // Simulated data, replace with actual data

    ///_dialogPoint(context);
    //f.cancel();
  });

  // _dialogPoint(context);
  f.cancel();
}
