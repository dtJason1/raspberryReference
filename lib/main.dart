import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:isolate';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String _message = 'Result will be displayed here';
  ReceivePort receivePort = ReceivePort();

  static void _backgroundWork(SendPort sendPort) {
    // 복잡한 계산 또는 작업을 수행
    while(true) {
      String result = "Background work completed";
      // 계산 결과를 메인 스레드로 전달
      sendPort.send(result);
      sleep(Duration(seconds: 3));
    }
  }

  // 백그라운드 작업을 실행하는 함수
  void _startBackgroundTask() async {

// 백그라운드 작업으로부터 메시지를 받습니다.
    receivePort.listen((data) {
      print(data);
      setState(() {
        _message = data;
      });
    });


    Isolate.spawn(_backgroundWork, receivePort.sendPort);

  }


  @override
  void initState(){
    _startBackgroundTask();
    //final sendport = receivePort.sendPort;

  }
  void sendPort(SendPort sendPort){
    sendPort.send("hello itsmee");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_message',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){sendPort(receivePort.sendPort);},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

