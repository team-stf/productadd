import 'package:flutter/material.dart';
import 'package:productadd/add/AddPage.dart';
import 'package:productadd/mgt/mgt.dart';
import 'MainPage.dart';
import 'add/CameraPage.dart';
import 'add/OldAdd.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '在庫管理システム',
      //テーマ設定
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      //ホーム読み込み
      home: const MainPage(),
      routes: {
        "/add": (BuildContext context) => AddPage(),
        "/mgt": (BuildContext context) => Mgt(),
        "/camera": (BuildContext context) => CameraPage(),
        "/oldadd": (BuildContext context) => OldAdd(),
      },
    );
  }
}
