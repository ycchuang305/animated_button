import 'package:animated_button/pushable_button.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _buttonTexts = [
    'PUSH ME',
    'ENROLL NOW',
    'ADD TO BASKET',
  ];

  final _colors = [
    Colors.redAccent,
    Colors.green,
    Colors.blue,
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final text = _currentIndex == 0 ? 'None' : '$_currentIndex';
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return PushableButton(
                  color: _colors[index],
                  text: _buttonTexts[index],
                  onPressed: () {
                    setState(() {
                      _currentIndex = index + 1;
                    });
                  },
                );
              },
              separatorBuilder: (_, __) => SizedBox(
                height: 30,
              ),
              itemCount: _buttonTexts.length,
            ),
            SizedBox(height: 30),
            Text(
              'Pushed: $text',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
