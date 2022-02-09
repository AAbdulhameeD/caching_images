import 'dart:async';
import 'dart:io' as Io;

///////////////////////////////////////////////////

import 'package:caching_images/DB/DBManger.dart';
import 'package:caching_images/Utilies/FileManger.dart';
import 'package:caching_images/download_image.dart';
import 'package:caching_images/models/image_model.dart';
import 'package:flutter/material.dart';

import 'Shared/constants/constants.dart';
import 'Utilies/ImagesManger.dart';
import 'download_image.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  var title = '';

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    //Future.delayed(const Duration(milliseconds: 0), () async {
       callingFilePath();

  }

  Future callingFilePath() async {
    globalFilePath = await FileManager().getCashedImagesFolderPath();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: globalFilePath.isEmpty? Center(child: CircularProgressIndicator(),) : Image(
                image: ImagesManager().loadImage(
                  url:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg',
                  type: APPS,
                  appId: 88,
                  moduleId: 12,
                  screenType: "a",
                  businessTypeId: 13,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: Icon(Icons
              .add)), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
