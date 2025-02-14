import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:rectangle_slider_thumb_shape/rectangle_slider_thumb_shape.dart';

class page_junner extends StatefulWidget {
  const page_junner({super.key});
  @override
  junner_state createState() => junner_state();
}

class junner_state extends State<page_junner> {
  double? frequency;
  String? note;
  int? octave;
  bool? isRecording;
  double? db_HZ;
  int? num_hz;
  double? slider_hz;
  String? n3;
  var result_D;
  var result_G;
  var result_A;
  var result_B;
  var result_E2;
  var result_E4;
  double? result;
  FlutterFft flutterFft = FlutterFft();
  var subscription;
  _initialize() async {
    print("Starting recorder...");

    // Keep asking for mic permission until accepted
    while (!(await flutterFft.checkPermission())) {
      flutterFft.requestPermission();
      // IF DENY QUIT PROGRAM
    }

    // await flutterFft.checkPermissions();
    await flutterFft.startRecorder();
    print("Recorder started...");
    setState(() => isRecording = flutterFft.getIsRecording);

    subscription = flutterFft.onRecorderStateChanged.listen(
        (data) async => {
              print("Changed state, received: $data"),
              setState(
                () => {
                  frequency = data[1] as double,
                  note = data[2] as String,
                  octave = data[5] as int,
                  db_HZ = frequency as double,
                  num_hz = db_HZ?.toInt(),
                  // slider_hz = 0,
                  print("top"),
                  //if (isCall == false){
                  result_D = Colors.white, //blue
                  result_G = Colors.white,
                  result_A = Colors.white,
                  result_B = Colors.white,
                  result_E2 = Colors.white,
                  result_E4 = Colors.white,
                  // result = num_hz!.toDouble() * 1000,
                  // print("Result: ${result}"),
                  if (num_hz! >= 62 && num_hz! <= 349)
                    {
                      if (num_hz! >= 62 && num_hz! <= 102)
                        {
                          if (num_hz! == 82)
                            {
                              slider_hz = 0,
                            }
                          else if (num_hz! > 82)
                            {
                              slider_hz = num_hz!.toDouble() - 82,
                            }
                          else if (num_hz! < 82)
                            {
                              slider_hz = num_hz!.toDouble() - 82,
                            },
                          n3 = "E",
                          result_E2 = Colors.green,
                          stop(),
                        }
                      else if (num_hz! >= 90 && num_hz! <= 130)
                        {
                          if (num_hz! == 110)
                            {
                              slider_hz = 0,
                            }
                          else if (num_hz! > 110)
                            {
                              slider_hz = num_hz!.toDouble() - 110,
                            }
                          else if (num_hz! < 110)
                            {
                              slider_hz = num_hz!.toDouble() - 110,
                            },
                          n3 = "A",
                          result_A = Colors.green,
                          stop(),
                        }
                      else if (num_hz! >= 126 && num_hz! <= 166)
                        {
                          if (num_hz! == 146)
                            {
                              slider_hz = 0,
                            }
                          else if (num_hz! > 146)
                            {
                              slider_hz = num_hz!.toDouble() - 146,
                            }
                          else if (num_hz! < 146)
                            {
                              slider_hz = num_hz!.toDouble() - 146,
                            },
                          n3 = "D",
                          result_D = Colors.green,
                          stop(),
                        }
                      else if (num_hz! >= 176 && num_hz! <= 216)
                        {
                          if (num_hz! == 196)
                            {
                              slider_hz = 0,
                            }
                          else if (num_hz! > 196)
                            {
                              slider_hz = num_hz!.toDouble() - 196,
                            }
                          else if (num_hz! < 196)
                            {
                              slider_hz = num_hz!.toDouble() - 196,
                            },
                          n3 = "G",
                          result_G = Colors.green,

                          stop(),
                          //จับเวลา 3 วิ -> เปิดใช้งานอีกครั้ง
                        }
                      else if (num_hz! >= 226 && num_hz! <= 266)
                        {
                          if (num_hz! == 246)
                            {
                              slider_hz = 0,
                            }
                          else if (num_hz! > 246)
                            {
                              slider_hz = num_hz!.toDouble() - 246,
                            }
                          else if (num_hz! < 246)
                            {
                              slider_hz = num_hz!.toDouble() - 246,
                            },
                          n3 = "B",
                          result_B = Colors.green,
                          stop(),
                        }
                      else if (num_hz! >= 309 && num_hz! <= 349)
                        {
                          if (num_hz! == 329)
                            {
                              slider_hz = 0,
                            }
                          else if (num_hz! > 329)
                            {
                              slider_hz = num_hz!.toDouble() - 329,
                            }
                          else if (num_hz! < 329)
                            {
                              slider_hz = num_hz!.toDouble() - 329,
                            },
                          n3 = "E",
                          result_E4 = Colors.green,
                          stop(),
                        }
                    }
                  else
                    {
                      n3 = "non",
                      slider_hz = 0,
                    },
                  //},
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

  @override
  void initState() {
    isRecording = flutterFft.getIsRecording;
    frequency = flutterFft.getFrequency;
    slider_hz = 0;
    note = flutterFft.getNote;
    octave = flutterFft.getOctave;
    super.initState();
    _initialize();
  }

  int _value = 50;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Tuner Page"),
        ),
        //backgroundColor: Color.fromARGB(207, 255, 255, 255),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'b',
                        style: TextStyle(height: 0, fontSize: 30),
                      ),
                      SizedBox(
                        width: 320,
                        height: 90,
                        // color: Colors.red[100]
                      ),
                      Text(
                        '#',
                        style: TextStyle(height: 0, fontSize: 30),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      //      Text(
                      //           'Value: ${slider_hz?.toInt()}', // แสดงค่าของ Slider ใน Label
                      //           style: TextStyle(fontSize: 25),
                      //         ),
                      //      Slider(
                      //   label: "${slider_hz}",
                      //   value: slider_hz!,
                      //   divisions: 4,
                      //   min: -20,
                      //   max: 20,
                      //   onChanged: (newRaiting) {
                      //     setState(() {
                      //       // raiting = newRaiting;
                      //     });
                      //   }
                      // ),
/*-------------------------- */

                      SfLinearGauge(
                        minimum: -20,
                        maximum: 20,
                        // ranges: _value,
                        showLabels: false,
                        showTicks: true,
                        interval: 2,
                        // onChanged: (value) {
                        //   setState(() {
                        //     // _value = value;
                        //   });
                        // },
                        // thumbShape: LinearThumbShape(
                        //   type: LinearThumbShapeType.circle,
                        //   color: Colors.blue,
                        //   size: 15,
                        // ),
                        markerPointers: [
                          LinearWidgetPointer(
                            value: slider_hz!,
                            position: LinearElementPosition.outside,
                            offset: 20,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  "${slider_hz?.toInt()}",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
// Stack(
//               alignment: Alignment.center,
//               children: <Widget>[
//                 Slider(
//                   value: slider_hz!,
//                   min: -20,
//                   max: 20,
//                   divisions: 40, // จำนวนแบ่งส่วนเท่ากับ 40 (20 * 2)
//                   onChanged: (double value) {
//                     setState(() {
//                       // _currentValue = value;
//                     });
//                   },
//                   label: slider_hz.toString(), // แสดง label ใน tooltip
//                 ),
//                 Positioned(
//                   left: 0,
//                   right: 0,
//                   bottom: 25,
//                   child: Text(
//                     slider_hz.toString(),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Current Value: $slider_hz',
//               style: TextStyle(fontSize: 24),
//             ),
// SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 activeTrackColor: Color.fromARGB(255, 156, 198, 244), // กำหนดสี Active Track เป็นสีโปร่งแสงหรือให้มองไม่เห็นได้
//               ),
//               child: Slider(
//                 value: slider_hz!,
//                 min: -20,
//                 max: 20,
//                 divisions: 40, // จำนวนแบ่งส่วนเท่ากับ 40 (20 * 2)
//                 onChanged: (double value) {
//                   setState(() {
//                     // _currentValue = value;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Current Value: $slider_hz',
//               style: TextStyle(fontSize: 24),
//             ),
                    ],
                  ),
                  // Column(
                  //   children: <Widget>[
                  //     SizedBox(
                  //       width: 340,
                  //       height: 40,
                  //       child: SfSlider(
                  //         min: -20,
                  //         max: 20,
                  //         interval: 2,
                  //         showTicks: true,
                  //         showLabels: false,
                  //         enableTooltip: false,
                  //         shouldAlwaysShowTooltip: true,
                  //         tooltipShape: const SfPaddleTooltipShape(),
                  //         value: slider_hz?.toInt(),
                  //         onChanged: (dynamic newValue) {
                  //           setState(() {
                  //             // _value = newValue;
                  //           });
                  //         },
                  //       ),
                  //       //color: Colors.red[100]
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   width: 340,
                  //   height: 60,
                  //   //color: Colors.red[100],
                  // ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        width: 64,
                        height: 50,
                        // color: Colors.red[100],
                        child: Text(""),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //  color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            backgroundColor: result_D,
                          ),
                          child: const Text(
                            "D",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 64,
                        height: 25,
                        // color: Colors.red[100],
                        child: Text(""),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        // color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            backgroundColor: result_A,
                          ),
                          child: const Text(
                            "A",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 64,
                        height: 25,
                        // color: Colors.red[100]
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        // color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            backgroundColor: result_E2,
                          ),
                          child: const Text(
                            "E",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 64,
                        height: 210,
                        // color: Colors.red[100]
                      ),
                    ],
                  ),
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        width: 230,
                        child: Image.asset("assets/bg.png"),
                        //color: Color.fromARGB(255, 211, 142, 120),
                      ),
                    ],
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 64,
                        height: 50,
                        // color: Colors.red[100],
                        child: Text(""),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //  color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: () {
                            // setState() {
                            Timer(const Duration(seconds: 3), () {
                              isRecording = flutterFft.getIsRecording;
                              frequency = flutterFft.getFrequency;
                              note = flutterFft.getNote;
                              octave = flutterFft.getOctave;
                              _initialize();
                            });
                            // };
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            backgroundColor: result_G,
                          ),
                          child: const Text(
                            "G",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 64,
                        height: 25,
                        // color: Colors.red[100]
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        //  color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            backgroundColor: result_B,
                          ),
                          child: const Text(
                            "B",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 64,
                        height: 25,
                        //   color: Colors.red[100]
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        // color: Colors.grey,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            backgroundColor: result_E4,
                          ),
                          child: const Text(
                            "E",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 64,
                        height: 210,
                        //   color: Colors.red[100]
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  void stop() {
    setState(() {
      isRecording = false;
      subscription.cancel();
      flutterFft.stopRecorder();
      print("stop");

      Timer(const Duration(seconds: 3), () {
        isRecording = flutterFft.getIsRecording;
        frequency = flutterFft.getFrequency;
        note = flutterFft.getNote;
        octave = flutterFft.getOctave;
        _initialize();
      });
    });
    /*setState(() {
      super.dispose();
      flutterFft.stopRecorder();
      print("stop");
    });*/
    //subscription.
  }
}
