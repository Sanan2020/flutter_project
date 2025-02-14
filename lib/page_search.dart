import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:http/http.dart' as http;
import 'behind_http.dart';
import 'dart:math';

class page_search extends StatefulWidget {
  const page_search({super.key});

  @override
  search_state createState() => search_state();
}

List<Map<dynamic, dynamic>> timeRangesList = [
  // {"A": "19.00-19.50"},
  // {"B": "20.00-20.50"},
  // {"C": "21.00-21.50"},
  // {"D": "18.00-18.50"},
];
List<Map<dynamic, dynamic>> timeRangesList2 = [
  // {"A": "19.00-19.50"},
  // {"B": "20.00-20.50"},
  // {"C": "21.00-21.50"},
  // {"D": "18.00-18.50"},
];
// ค่าที่ต้องการค้นหา
double? targetValue;
bool? foundValue;
List<String> top = ["-", "-", "-"];
List<String> topf = ["-", "-", "-"];

String? txt = "";

var subscription;

int count = 1;
String picture = "not_found.jpg";
String chords = "";
String id = "";
String freqS = "";
String freqE = "";
// ignore: prefer_typing_uninitialized_variables
var data;
int lcount = 0;

class search_state extends State<page_search> {
  double? frequency;
  int? frequency2;
  int? percen;
  String? note;
  // String? note2;
  int? octave;
  bool? isRecording;
  FlutterFft flutterFft = FlutterFft();

  Future _loadAll() async {
    var url = Uri.parse("${dataURL}page_search.php");
    var response = await http.post(url);
    data = json.decode(response.body);
    if (data != 'non') {
      setState(() => {
            id = data[count]['id'],
            chords = data[count]['chords'],
            picture = data[count]['pic'],
            freqS = data[count]['freq_start'],
            freqE = data[count]['freq_end'],
            lcount = int.parse(data[count]['lcount']),
            print(lcount),
          });

      for (int i = 0; i < lcount; i++) {
        timeRangesList.add({
          "${data[i]['chords']}":
              "${data[i]['freq_start']}-${data[i]['freq_end']}"
        });
        timeRangesList2.add({
          "${data[i]['chords']}":
              "${data[i]['freq_start']}-${data[i]['freq_end']}"
        });
      }
    } else {
      // ignore: avoid_print
      print("not");
      //ไม่พบข้อมูล
    }
  }

  _initialize() async {
    // ignore: avoid_print
    print("Starting recorder...");
    txt = "กำลังประมวลผล...";
    top = ["กำลังประมวลผล...", "กำลังประมวลผล...", "กำลังประมวลผล..."];
    topf = ["-", "-", "-"];
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
    // ignore: avoid_print
    print("Recorder started...");
    setState(() => isRecording = flutterFft.getIsRecording);
    subscription = flutterFft.onRecorderStateChanged.listen(
        (data) => {
              // ignore: avoid_print
              print("Changed state, received: $data"),
              setState(
                () => {
                  frequency = data[1] as double,
                  frequency2 = frequency?.toInt(),
                  percen = 0,
                  note = data[2] as String,
                  octave = data[5] as int,

                  // ใช้ Map เพื่อเก็บคีย์และค่าของแต่ละย่าน
                  //targetValue = frequency,
                  // targetValue = 46.32,
                  targetValue = double.parse(frequency!.toStringAsFixed(2)),
                  // ใช้ 'entries' เพื่อ iterate ผ่าน Map
                  // และแสดงคีย์พร้อมกับการตรวจสอบว่าค่าที่ต้องการอยู่ในย่านหรือไม่
                  foundValue = false,
                  // ignore: avoid_function_literals_in_foreach_calls
                  timeRangesList.forEach((timeRangesList) {
                    // ignore: avoid_function_literals_in_foreach_calls
                    timeRangesList.entries.forEach((entry) {
                      if (isValueInRange(targetValue!, entry.value)) {
                        // ignore: avoid_print
                        print(
                            "ค้นพบค่า $targetValue ใน Map ด้วยคีย์ ${entry.key}");
                        foundValue = true;
                        stop();

                        // // ค่าที่ต้องการค้นหา
                        // String targetValue2 = "$targetValue"; /* จัดการ */
                        // //String targetValue2 = "24.60";
                        // // หาค่าที่ใกล้เคียงที่สุด 3 ค่า
                        // List<Map<dynamic, dynamic>> closestValues = findClosestValues(timeRangesList2, targetValue2, 3);

                        // // แสดงผลลัพธ์
                        // top.clear();
                        // topf.clear();
                        // // ignore: avoid_function_literals_in_foreach_calls
                        // closestValues.forEach((value) {
                        //   value.forEach((key, range) {
                        //     // ignore: avoid_print
                        //     print("ค่าที่ใกล้เคียงกับ $targetValue คือ Map ด้วยคีย์ $key ที่มีค่า $range");

                        //     top.add(key);
                        //     topf.add(range);
                        //   });
                        // });

                        // String targetValue2 = "32.85";
                        String targetValue2 = "$targetValue";
                        // ค้นหาค่าที่ใกล้เคียงที่สุด 2 ค่า
                        List<Map<dynamic, dynamic>> closestValues =
                            findClosestValues(timeRangesList2, targetValue2, 3);

                        top.clear();
                        topf.clear();
                        // แสดงผลลัพธ์
                        closestValues.forEach((value) {
                          value.forEach((key, range) {
                            print(
                                "ค่าที่ใกล้เคียงกับ $targetValue2 คือ Map ด้วยคีย์ $key ที่มีค่า $range");
                            top.add(key);
                            topf.add(range);
                          });
                        });
                      }
                    });
                  }),

                  if (!foundValue!)
                    {
                      // ignore: avoid_print
                      print("ไม่พบค่า $targetValue ใน Map"),
                      txt = "กำลังประมวลผล...",
                    }
                },
              ),
              flutterFft.setNote = note!,
              flutterFft.setFrequency = frequency!,
              flutterFft.setOctave = octave!,
              // ignore: avoid_print
              print("Octave: ${octave!.toString()}")
            },
        onError: (err) {
          // ignore: avoid_print
          print("Error: $err");
        },
        // ignore: avoid_print
        onDone: () => {print("Isdone")});
  }

  @override
  void initState() {
    _loadAll();
    super.initState();

    // _initialize();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
    subscription.cancel();
    isRecording = false;
    flutterFft.stopRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("chords search Page"),
      ),
      // backgroundColor: Color.fromARGB(207, 255, 255, 255),
      body: Stack(children: [
        ListView(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              backgroundColor: const Color(0xff764abc),
              child: const Icon(
                Icons.mic,
                size: 35,
              ),
              onPressed: () {
                // _startSpeechRecognition();
                isRecording = flutterFft.getIsRecording;
                frequency = flutterFft.getFrequency;
                frequency2 = frequency?.toInt();
                percen = frequency2;
                note = flutterFft.getNote;
                // note2 = flutterFft.getNote;
                octave = flutterFft.getOctave;
                _initialize();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 7, 217, 179),
                child: Text("1"),
              ),
              title: top.isNotEmpty ? Text('คอร์ด : ${top[0]}') : Text('$txt'),
              subtitle:
                  topf.isNotEmpty ? Text('ความถี่ : ${topf[0]}') : Text('-'),
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 7, 217, 179),
                child: Text("2"),
              ),
              title: top.isNotEmpty ? Text('คอร์ด : ${top[1]}') : Text('$txt'),
              subtitle:
                  topf.isNotEmpty ? Text('ความถี่ : ${topf[1]}') : Text('-'),
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 7, 217, 179),
                child: Text("3"),
              ),
              title: top.isNotEmpty ? Text('คอร์ด : ${top[2]}') : Text('$txt'),
              subtitle:
                  topf.isNotEmpty ? Text('ความถี่ : ${topf[2]}') : Text('-'),
            ),
            const Divider(
              color: Colors.black,
            ),
          ],
        ),
      ]));

  void stop() {
    setState(() {
      isRecording = false;
      subscription.cancel();
      flutterFft.stopRecorder();
      txt = "";
      print("stop");
    });
  }
}

//for search
bool isValueInRange(double value, String timeRange) {
  List<double> range =
      timeRange.split('-').map((time) => double.parse(time)).toList();
  return range[0] <= value && value <= range[1];
}

//for 3 result
// ฟังก์ชันหาค่าที่ใกล้เคียงที่สุด
// List<Map<dynamic, dynamic>> findClosestValues(
//     List<Map<dynamic, dynamic>> list, String targetValue, int numClosest) {
//   // แปลง targetValue เป็น List ของ double
//   List<double> targetRange =
//       targetValue.split('-').map((time) => double.parse(time)).toList();

//   // สร้าง List ไว้เก็บค่าที่ใกล้เคียงที่สุด
//   List<Map<dynamic, dynamic>> closestValues = [];

//   // หาค่าที่ใกล้เคียงที่สุด
//   list.sort((a, b) {
//     double rangeA =
//         a.values.first.split('-').map((time) => double.parse(time)).toList()[0];
//     double rangeB =
//         b.values.first.split('-').map((time) => double.parse(time)).toList()[0];
//     double diffA = (rangeA - targetRange[0]).abs();
//     double diffB = (rangeB - targetRange[0]).abs();
//     return diffA.compareTo(diffB);
//   });

//   // เลือกจำนวนค่าที่ใกล้เคียงที่สุดตามที่กำหนด
//   for (int i = 0; i < numClosest && i < list.length; i++) {
//     closestValues.add(list[i]);
//   }

//   return closestValues;
// }

//V.2
// ฟังก์ชันหาค่าที่ใกล้เคียงที่สุด
List<Map<dynamic, dynamic>> findClosestValues(
    List<Map<dynamic, dynamic>> list, String targetValue, int numClosest) {
  // แปลง targetValue เป็น List ของ double
  List<double> targetRange =
      targetValue.split('-').map((time) => double.parse(time)).toList();

  // สร้าง List ไว้เก็บค่าที่ใกล้เคียงที่สุด
  List<Map<dynamic, dynamic>> closestValues = [];

  // หาค่าที่ใกล้เคียงที่สุด
  list.sort((a, b) {
    double rangeAStart = double.parse(a.values.first.split('-')[0]);
    double rangeAEnd = double.parse(a.values.first.split('-')[1]);
    double rangeBStart = double.parse(b.values.first.split('-')[0]);
    double rangeBEnd = double.parse(b.values.first.split('-')[1]);

    double diffAStart = (rangeAStart - targetRange[0]).abs();
    double diffAEnd = (rangeAEnd - targetRange[0]).abs();
    double diffBStart = (rangeBStart - targetRange[0]).abs();
    double diffBEnd = (rangeBEnd - targetRange[0]).abs();

    double diffA = min(diffAStart, diffAEnd);
    double diffB = min(diffBStart, diffBEnd);

    return diffA.compareTo(diffB);
  });

  // เลือกจำนวนค่าที่ใกล้เคียงที่สุดตามที่กำหนด
  for (int i = 0; i < numClosest && i < list.length; i++) {
    closestValues.add(list[i]);
  }

  return closestValues;
}
