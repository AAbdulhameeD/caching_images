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

class MyHttpOverrides extends Io.HttpOverrides {
  @override
  Io.HttpClient createHttpClient(Io.SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (Io.X509Certificate cert, String host, int port) => true;
  }
}

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
  var title='';

  MyHomePage({Key key, this.title}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () async {
      globalFilePath = await FileManger().getCashedImagesFolderPath();
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
              child: Image(
                image: ImagesManger().loadImage(
                  url:
                      "https://png.pngitem.com/pimgs/s/466-4661960_transpaart-serbian-kids.png",
                  type: APPS,
                  appId: 11,
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
          onPressed: ()  {
          },
          tooltip: 'Increment',
          child: Icon(Icons.add)
          ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

