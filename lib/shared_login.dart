import 'package:flutter/material.dart';
import 'package:flutter_project/menu.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class shared_login extends StatefulWidget {
  @override
  _VerticalImageSliderState createState() => _VerticalImageSliderState();
}

double _scrollPosition = 0;
final double _scrollSpeed = 50; // ความเร็วในการเลื่อน

class _VerticalImageSliderState extends State<shared_login> {
  final _scrollController = ScrollController();
  Timer? _timer;
  int _currentPage = 0;
  final List<String> imageUrls = [
    'https://c9b1-27-55-72-70.ngrok-free.app/tt.png',
    'https://c9b1-27-55-72-70.ngrok-free.app/tt2.png',
    'https://c9b1-27-55-72-70.ngrok-free.app/tt3.png',
    'https://c9b1-27-55-72-70.ngrok-free.app/tt4.png',
  ];

  @override
  void initState() {
    super.initState();
    startScrolling();
  }

  var cn = 0;
  var opac;
  void startScrolling() {
    Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      setState(() => {
            cn++,

            if (cn == items.length)
              {
                cn = 0,
              },
            // if (cn < items.length)
            //   {
            //     opac = items[cn + 1],
            //   }
          });
    });
  }

  final List<String> items = [
    "G",
    "Em",
    "C",
    "D",
    "Bm",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Practice Page"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // height: 300, // กำหนดความสูงของ ListView
            child: Text(
              items[cn],
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Container(
            height: 15, // กำหนดความสูงของ ListView
            width: 10,
            color: Colors.black,
          ),
          Container(
            //  height: 300, // กำหนดความสูงของ ListView
            child: Opacity(
              opacity: 0.3,
              child: Text(
                '${opac}'.isNotEmpty ? '' : '',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
