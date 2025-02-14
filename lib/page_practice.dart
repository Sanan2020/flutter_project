import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'behind_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';

class page_practice extends StatefulWidget {
  final String practiceId;
  const page_practice({Key? key, required this.practiceId}) : super(key: key);

  @override
  practice_State createState() => practice_State();
}

var data;
var datalss;
int count = 0;
String song = "";
String chords = "";
String id = "";
int lcount = 0;
int lcountlss = 0;

ScrollController _scrollController = ScrollController();
double _scrollPosition = 0;
final double _scrollSpeed = 10; // ความเร็วในการเลื่อน

FlutterFft flutterFft = FlutterFft();
var subscription;

int _minutes = 0;
int _seconds = 0;
Timer? _timer;

String? btnStart = "Start";
Completer<void> _completer = Completer<void>();
List imgList = [
  ["Name music", "C  D  G  E", 32.80, 32.86],
  ["Dsus4", Image.asset('Image/_cordDsus4.png'), 73.08, 73.69],
  ["Asus4", Image.asset('Image/_cordAsus4.png'), 18.28, 18.33],
  ["Dsus2", Image.asset('Image/_cordDsus2.png'), 36.31, 36.65],
  // Image.asset('Images/S2.png'),
];

int point = 0;
bool? _isDisable = false;

var tem1 = Color.fromARGB(255, 192, 190, 190);
var tem2 = Color.fromARGB(255, 225, 223, 223);
var tem3 = Color.fromARGB(255, 192, 190, 190);
var tem4 = Color.fromARGB(255, 225, 223, 223);
var tem5 = Color.fromARGB(255, 192, 190, 190);
var tem6 = Color.fromARGB(255, 225, 223, 223);
var tem7 = Color.fromARGB(255, 192, 190, 190);
var tem8 = Color.fromARGB(255, 225, 223, 223);
int da = 0;
var cn = 0;
var cnn = 1;
var conti = false;
List<String> resultList = ["-", "-"];

var periodicTimer;
var timer;
List<Map<dynamic, dynamic>> timeRangesList3 = [
  // {"A": "19.00-19.50"},
  // {"B": "20.00-20.50"},
  // {"C": "21.00-21.50"},
  // {"D": "18.00-18.50"},
];

class practice_State extends State<page_practice> {
  // Future _savePoint() async {
  //   /* Get user_id */
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   useid = prefs.getString('useid') ?? '';
  //   // print("useid :" + useid);

  //   var url = Uri.parse("${dataURL}point_lesson.php");
  //   response = http.post(url, body: {
  //     "user_id": useid,
  //     "lesson_id": id,
  //     "lesson_score": point.toString(),
  //   });
  // }

  double? frequency;
  int? frequency2;
  String? note;
  String? note2;
  int? octave;
  bool? isRecording;

  int nextCord = 0;
  var ImgCount = imgList.length;
  List<String> startTimes = [];
  List<String> endTimes = [];

  _initialize() async {
    print("Starting recorder...");
    _startTimer();

    periodicTimer = Timer.periodic(
      const Duration(milliseconds: 800),
      (timer) {
        print("Timer tick: ${timer.tick}");
        setState(() => {
              da++,
              tem1 = Color.fromARGB(255, 192, 190, 190),
              tem2 = Color.fromARGB(255, 225, 223, 223),
              tem3 = Color.fromARGB(255, 192, 190, 190),
              tem4 = Color.fromARGB(255, 225, 223, 223),
              tem5 = Color.fromARGB(255, 192, 190, 190),
              tem6 = Color.fromARGB(255, 225, 223, 223),
              tem7 = Color.fromARGB(255, 192, 190, 190),
              tem8 = Color.fromARGB(255, 225, 223, 223),
              if (da == 1)
                {
                  tem1 = const Color.fromARGB(255, 69, 168, 84),
                  if (conti == true)
                    {
                      //ครั้งแรกไม่ต้องเปลี่ยนคอร์ด
                      cn++,
                      cnn++,
                    },
                  conti = true,
                  if (cn == resultList.length)
                    {
                      //เมื่อถึง
                      cn = 0,
                    },
                  if (cnn == resultList.length)
                    {
                      //เมื่อถึง
                      cnn = 0,
                    },
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
                }
              else if (da == 7)
                {
                  tem7 = const Color.fromARGB(255, 69, 168, 84),
                }
              else if (da == 8)
                {
                  tem8 = const Color.fromARGB(255, 69, 168, 84),
                  da = 0,
                }
            });
      },
    );

    btnStart = "Stop";

    // Keep asking for mic permission until accepted
    while (!(await flutterFft.checkPermission())) {
      flutterFft.requestPermission();
      // IF DENY QUIT PROGRAM
    }

    // await flutterFft.checkPermissions();
    await flutterFft.startRecorder();
    print("Recorder started...");
    setState(() => isRecording = flutterFft.getIsRecording);

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
                  //  v = frequency!.toStringAsFixed(2),
                  //  inDouble = double.parse(v),
                  //_textEditingController.text = note.toString(),
                  // if (frequency! >= 32.56 && frequency! <= 32.86) //C7
                  print(startTimes[cn] + " " + endTimes[cn]),
                  // input = double.parse(frequency!.toStringAsFixed(2)),
                  input = 24.48,
                  if (input >= double.parse(startTimes[cn]) &&
                      input <= double.parse(endTimes[cn]))
                    {
                      print(startTimes[cn] + " " + endTimes[cn]),
                    },
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

  void _Start() {
    da = 0;
    _initialize();

    //super.initState();
  }

  Future _loadPractice() async {
    var url = Uri.parse("${dataURL}page_practice.php");
    // var response = await http.post(url);
    var response =
        await http.post(url, body: {"type": widget.practiceId.toString()});
    data = json.decode(response.body);
    if (data != 'non') {
      //show_error("เข้าสู่ระบบสำเร็จ");
      setState(() => {
            // resultList?.clear(),
            id = data[count]['id'],
            chords = data[count]['chords'],
            song = data[count]['song'],
            // freqS = data[count]['freq_start'],
            // freqE = data[count]['freq_end'],
            lcount = int.parse(data[count]['lcount']),

            resultList = chords.split(","),
            print(resultList),
          });
    } else {
      print("not");
      //ไม่พบข้อมูล
    }
  }

  void _next() {
    setState(() => {
          id = data[count]['id'],
          chords = data[count]['chords'],
          song = data[count]['song'],
          // picture = data[count]['pic'],
          // freqS = data[count]['freq_start'],
          // freqE = data[count]['freq_end'],
          lcount = int.parse(data[count]['lcount']),
          resultList = chords.split(","),
          print(lcount),
        });

    print(timeRangesList3);
    List<Map<dynamic, dynamic>> selectedItems = [];
    // ไอเทมที่ต้องการหา
    List<String> itemsToFind = ["B", "D(1)"];

    // วนลูปเพื่อหาไอเทมที่ต้องการ
    for (var item in timeRangesList3) {
      // ตรวจสอบว่าไอเทมอยู่ในรายการที่ต้องการหาหรือไม่
      if (resultList.contains(item.keys.first)) {
        // เพิ่มไอเทมที่พบเข้าไปในรายการ selectedItems
        selectedItems.add(item);
      }
    }
    // แสดงผลลัพธ์
    print(selectedItems);
    // print(selectedItems[0][0]);
    //  print(selectedItems[0]['freq_start']);
    //test
    // สร้างรายการเพื่อเก็บค่าเริ่มต้นและสิ้นสุดของช่วงเวลา

    startTimes.clear();
    endTimes.clear();
// วนลูปผ่านทุกไอเทมใน selectedItems
    for (var item in selectedItems) {
      // ดึงช่วงเวลาออกมาจากคีย์และค่าของไอเทม
      String timeRange = item.values.first;

      // แยกช่วงเวลาออกเป็นสองส่วนโดยใช้เครื่องหมาย "-"
      List<String> splitTimeRange = timeRange.split("-");

      // นำค่าเริ่มต้นและสิ้นสุดของช่วงเวลามาเก็บไว้
      startTimes.add(splitTimeRange[0]);
      endTimes.add(splitTimeRange[1]);
    }

// แสดงผลลัพธ์
    print("Start times: $startTimes");
    print("End times: $endTimes");
  }

  Future _loadAll() async {
    var url = Uri.parse("${dataURL}page_search.php");
    var response = await http.post(url);
    datalss = json.decode(response.body);
    if (datalss != 'non') {
      setState(() => {
            lcountlss = int.parse(datalss[count]['lcount']),
            print(lcountlss),
          });

      for (int i = 0; i < lcountlss; i++) {
        timeRangesList3.add({
          "${datalss[i]['chords']}":
              "${datalss[i]['freq_start']}-${datalss[i]['freq_end']}"
        });
      }
      print(timeRangesList3);
      List<Map<dynamic, dynamic>> selectedItems = [];
      // ไอเทมที่ต้องการหา
      List<String> itemsToFind = ["B", "D(1)"];

      // วนลูปเพื่อหาไอเทมที่ต้องการ
      for (var item in timeRangesList3) {
        // ตรวจสอบว่าไอเทมอยู่ในรายการที่ต้องการหาหรือไม่
        if (resultList.contains(item.keys.first)) {
          // เพิ่มไอเทมที่พบเข้าไปในรายการ selectedItems
          selectedItems.add(item);
        }
      }
      // แสดงผลลัพธ์
      print(selectedItems);

      //behind_http.dart    startTimes.clear();
      endTimes.clear();
// วนลูปผ่านทุกไอเทมใน selectedItems
      for (var item in selectedItems) {
        // ดึงช่วงเวลาออกมาจากคีย์และค่าของไอเทม
        String timeRange = item.values.first;

        // แยกช่วงเวลาออกเป็นสองส่วนโดยใช้เครื่องหมาย "-"
        List<String> splitTimeRange = timeRange.split("-");

        // นำค่าเริ่มต้นและสิ้นสุดของช่วงเวลามาเก็บไว้
        startTimes.add(splitTimeRange[0]);
        endTimes.add(splitTimeRange[1]);
      }

// แสดงผลลัพธ์
      print("Start times: $startTimes");
      print("End times: $endTimes");
    } else {
      // ignore: avoid_print
      print("not lesson");
      //ไม่พบข้อมูล
    }
  }

  @override
  void initState() {
    print(widget.practiceId);
    _loadAll();
    _loadPractice();

    isRecording = flutterFft.getIsRecording;
    frequency = flutterFft.getFrequency;
    frequency2 = 0;
    note = flutterFft.getNote;
    note2 = flutterFft.getNote;
    octave = flutterFft.getOctave;
    // _textEditingController.text = "listen...";
    super.initState();
    //  _initialize();

    // startScrolling();
    // _startTimer();
    // Timer.periodic(const Duration(milliseconds: 2000), (timer) {
    //   setState(() => {
    //         cn++,

    //         if(cn == items.length){
    //             cn = 0,
    //         },
    //         // if (cn < items.length)
    //         //   {
    //         //     opac = items[cn + 1],
    //         //   }
    //       });
    // });
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      //setState(() {
      if (_minutes < 2) {
        //2
        if (_seconds < 59) {
          _seconds++;
        } else {
          _seconds = 0;
          _minutes++;
        }
      } else {
        stop();
        setState(() {
          timer.cancel();
          _dialogPoint(context);
        });
      }
    });

    // });
  }

  String dropdownValue = '4/4';
  bool isVisible = false;
  int maxroom = 4;
  final List<String> items = [
    "1G",
    "2Em",
    "3C",
    "4D",
    "5Bm",
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.practiceId),
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
            count = 0;
            timeRangesList3.clear();
            return true; // ตัวอย่าง: อนุญาตให้ย้อนกลับ
          },
          child: Column(
            children: <Widget>[
              Container(
                width: 100,
                height: 10,
                // color: Color.fromARGB(255, 15, 187, 9)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 65,
                    height: 40,
                    //color: Color.fromARGB(255, 208, 84, 11)
                  ),
                  Text('Practice no. ${count + 1}/$lcount'),
                  SizedBox(
                    width: 75,
                    height: 50,
                    child: Container(
                      // color: Colors.blue, // สีที่คุณต้องการใส่ให้กับ SizedBox
                      child: Visibility(
                        visible:
                            true, // กำหนดให้เป็น true หรือ false ตามตัวแปร vis
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
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 180,
                    height: 60,
                    child: Container(
                      //color: Color.fromARGB(255, 78, 157,111), // สีที่คุณต้องการใส่ให้กับ SizedBox
                      child: Center(
                        child: Text(
                          song,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
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
                ],
              ),
              Container(
                  width: 250,
                  height: 120,
                  //padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  color: Color.fromARGB(255, 238, 249, 251)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 35,
                      height: 60,
                      color: Color.fromARGB(255, 238, 249, 251)),
                  SizedBox(
                    width: 90,
                    height: 60,
                    child: Container(
                        color: Color.fromARGB(255, 103, 149,
                            141), // สีที่คุณต้องการใส่ให้กับ SizedBox
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            resultList[cn],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 90,
                    height: 60,
                    child: Opacity(
                      opacity: 0.3, // กำหนดค่าความโปร่งใส
                      child: Container(
                        color: Color.fromARGB(255, 103, 149, 141),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            resultList[cnn],
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 213, 192, 192),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width: 35,
                      height: 60,
                      color: Color.fromARGB(255, 238, 249, 251)),
                ],
              ),
              Container(
                  width: 250,
                  height: 120,
                  color: Color.fromARGB(255, 238, 249, 251)),
              Container(width: 10, height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 40, height: 40, color: tem1),
                  Container(width: 40, height: 40, color: tem2),
                  Container(width: 40, height: 40, color: tem3),
                  Container(width: 40, height: 40, color: tem4),
                  Container(
                      width: 5,
                      height: 40,
                      color: Color.fromARGB(255, 40, 42, 40)),
                  Container(width: 40, height: 40, color: tem5),
                  Container(width: 40, height: 40, color: tem6),
                  Container(width: 40, height: 40, color: tem7),
                  Container(width: 40, height: 40, color: tem8),
                ],
              ),

              /* -------------------------------------------------- */

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //  color: Colors.grey,
                    child: ElevatedButton(
                      onPressed: () {
                        // _initialize();
                        // setState(() => _initialize());
                        //initState();
                        point = 0;
                        if (isRecording!) {
                          //    setState(() {
                          // timer.cancel();
                          // });
                          stop();
                          btnStart = "Start";
                        } else {
                          setState(() {
                            //isRecording = false;
                            // subscription.start();
                            //flutterFft.startRecorder();
                            //super.initState();

                            //_initialize();
                            _Start();
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 78, 175, 22),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$_minutes:${_seconds < 10 ? '0$_seconds' : _seconds}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  void stop() {
    // periodicTimer.cancel();
    setState(() {
      cn = 0;
      cnn = 1;
      btnStart = "Start";
      isRecording = false;
      subscription.cancel();
      flutterFft.stopRecorder();
      periodicTimer.cancel();
      // isRecording = false;
      // subscription.cancel();
      // flutterFft.stopRecorder();
      // subscription.cancel();
      // periodicTimer.cancel();

      print("stop");

      tem1 = Color.fromARGB(255, 192, 190, 190);
      tem2 = Color.fromARGB(255, 225, 223, 223);
      tem3 = tem1;
      tem4 = tem2;
      tem5 = tem1;
      tem6 = tem2;
      tem7 = tem1;
      tem8 = tem2;
      Timer(Duration(seconds: 1), () {
        // subscription.cancel();
        // flutterFft.stopRecorder();
        //  isRecording = false;
        // subscription.cancel();
      });
    });
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
