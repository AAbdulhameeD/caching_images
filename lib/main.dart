import 'dart:io' as Io;

import 'dart:math';

///////////////////////////////////////////////////

import 'package:caching_images/DB/DBManger.dart';
import 'package:caching_images/download_image.dart';
import 'package:caching_images/models/image_model.dart';
import 'package:caching_images/save_img.dart';
import 'package:flutter/material.dart';

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
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DBManager dbManager = DBManager();
  Io.File file;
  var folderPath='';

  ImageModel imgModel = ImageModel(
      appId: 11,
      businessTypeID: 22,
      imgType: 23,
      moduleId: 44,
      screenType: 'aa',
      imgUrl:
          "https://media.gemini.media/img/large/2019/7/23/2019_7_23_15_8_47_840.jpg");
  int _counter = 0;
  String filePath;

  List<ImageModel> list = [];

  Future<void> isDbContainsUrl(
      List<ImageModel> list, ImageModel newModel) async {
    print(list.length);
    if (list.length == 0) {
      print('iam here');

      await DownloadImage()
          .downloadImage(url: newModel.imgUrl, fileName: newModel.getImageName('png'));
      await dbManager.insertImageIntoDB(newModel);
      setState(() {
        newModel.isInDB = true;
      });
    } else {
      for (var item in list) {
        print('${item.appId} appid');
        if ( newModel.imgUrl.compareTo(item.imgUrl) == 0) {
          //TODO check image in local Storage, if it's not exists download it
          bool isInLocal =  DownloadImage()
              .isInLocal("${newModel.getImageName("png")}",folderPath);
          print(isInLocal);
          if (!isInLocal) {
            DownloadImage().downloadImage(
                url:  newModel.imgUrl, fileName: "${newModel.getImageName("png")}");
          }
          setState(() {
            item.isInDB = true;
          });
        } else {
          //TODO download the img and insert the model in DB
          await DownloadImage().downloadImage(
              url:  newModel.imgUrl, fileName: "${newModel.getImageName("png")}");
          setState(() {
            item.isInDB = false;
          });
          //dbManager.insertImageIntoDB(newModel);
        }
      }
    }
  }

  void getLocalImage( ImageModel model) async {
    //await  dbManager.insertImageIntoDB(ImageModel(imgUrl: "aaa",appId: 13,businessTypeID: 10,moduleId: 5,imgType: PROFILE_lOGO,screenType: 'a'));
    // var response = await HttpHelper.getData(
    //     "https://mocki.io/v1/5a9ed1bc-e945-41b1-b6ab-c9b6a99ecc55");
    // ImgUrlModel imgUrlModel = EncodeAndDecodeImg.decodeImgUrl(response.body);
    // print('${imgUrlModel.loginBackground} loginBackground');
    dbManager.getImageByType(model.imgType).then((value) {
      for (var i = 0; i < value.length; i++) {
        list.add(ImageModel.fromJson(value[i]));
      }
    });
    dbManager.getImageByAppId(model.appId).then((value) {
      for (var i = 0; i < value.length; i++) {
        list.add(ImageModel.fromJson(value[i]));
      }
    });
    dbManager
        .getImageByModuleIdAndAppId(model.moduleId, model.appId)
        .then((value) {
      for (var i = 0; i < value.length; i++) {
        list.add(ImageModel.fromJson(value[i]));
      }
    });
    dbManager
        .getImageByScreenTypeAndBusinessId(
            model.appId, model.screenType, model.businessTypeID)
        .then((value) async {
      for (var i = 0; i < value.length; i++) {
        list.add(ImageModel.fromJson(value[i]));
      }
      await isDbContainsUrl( list, model);
      //   print('${img.isInDB} is in Db ?');
    });
    // list.add(await dbManager.getImageByAppId(2));
    // var imgModel = ImageModel.fromJson(list[0]);
    // for(var ele in list){
    //   print('${}')
    // }

    // dbManager.deleteAllImages();
    //  DownloadImage().downloadFile(
    //      "https://media.gemini.media/img/large/2019/7/23/2019_7_23_15_8_47_840.jpg",
    //    imageModel: ImageModel(imgType:PROFILE_lOGO,moduleId: 22,businessTypeID: 33,appId: 44,screenType: "as", imgUrl: 'aasa')
    //  );
    //      dbManager.deleteAllImages();
    //    //dbManager.insertImageIntoDB('http://asssd', 11, 13, 51, 0, 81);

    //    var list=await dbManager.getImageByAppId(13);
    //    var imgModel= ImageModel.fromJson(list[0]);
    //      String a="aaa";
    //      String c='aaa';
    //
    //      String b=imgModel.imgUrl.toString();
    //      int eq=a.compareTo(imgModel.imgUrl);
    //     print('${imgModel.imgUrl==a} imggg eeee');

    //  dynamic img=await dbManager.getImageByBusinessTypeId(81);
    // print('${img[0]} img');
    //  dynamic img2=await dbManager.getImageByAppId(13);
    // var e=   dbManager.getImageByModuleId(5).then((val) {
    //   print('$val val');
    // });

    //print('${{await dbManager.getImageByAppId(13)}} img');
    // print('$e img eeee');
    // print('${await dbManager.getImageByScreenId(0)} img');
    // print('${await dbManager.getImageByBusinessTypeId(81)} img');
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    folderPath= await getFilePathString();

  }

  @override
  void initState() {

    super.initState();

    Future.delayed(const Duration(milliseconds: 0), () async {
      folderPath= await getFilePathString();

    });
    /*
    Future.delayed(const Duration(milliseconds: 500), () async {
      await DownloadImage()
          .getFilePath('${imgModel.getImageName("png")}')
          .then((value) => filePath = value);*/

    // file = await SaveFile().saveImage("https://media.gemini.media/img/large/2019/7/23/2019_7_23_15_8_47_840.jpg");
    // print('${file}file path');
    //
    // setState(() {
    //   print('${file}file path');
    // });
  }

//await dbManager.insertImageIntoDB('http://asd', 1, 3, 5, 10, 8);

  Future<String> getFilePathString() async {
     return await DownloadImage()
        .getFilePath();
  }

  Io.File getUiImage(String imgName){
    try{
     if(DownloadImage().isInLocal('$imgName', folderPath)){
       return Io.File('$folderPath/$imgName');
     }else{
       return Io.File('$folderPath/28-11.PNG');

     }
      print('$folderPath folder path contains image?  ');}catch(e){
      print('$e');
      return Io.File('$folderPath/28-11.PNG');

    }
  }
  @override
  Widget build(BuildContext context) {


   Io.File file = getUiImage(imgModel.getImageName('png'));

  //  Io.File file = Io.File(filePath);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: Image(
                image: FileImage(getUiImage(imgModel.getImageName('png'))),
              ),
            )
            /* Container(
              child: //imgModel.isInDB ?
              Image(
                image: FileImage(file),
              ),
          Text(
            '$_counter',
            style: Theme
                .of(context)
                .textTheme
                .headline4,
          ),
          ),*/
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            getLocalImage(imgModel);
            setState(() {

            });
            // getLocalImage(
            //   "https://media.gemini.media/img/large/2019/7/23/2019_7_23_15_8_47_840.jpg",
            //   ImageModel(
            //     imgUrl:
            //     "https://media.gemini.media/img/large/2019/7/23/2019_7_23_15_8_47_840.jpg",
            //     screenType: "aa",
            //     appId: 2,
            //     businessTypeID: 22,
            //     moduleId: 21,
            //     imgType: 11,
            //   ),
            // );
            // print('${await dbManager.getImageByType(11)} img');

            // await DownloadImage().downloadImage(url: "https://media.gemini.media/img/large/2019/7/23/2019_7_23_15_8_47_840.jpg"
            //      , fileName: 'fareedddd');

            //print('${await DownloadImage().isInLocal('ahmeddd.png')} is in local');
            // /print("${await DownloadImage().isInLocal("gemini.jpg")} is in local");
            //  if (file == null)
            //    print('nulll');

            // String  filePath = await SaveFile().saveImage("https://media.gemini.media/img/large/2019/7/23/2019_7_23_15_8_47_840.jpg").then((value) {
            //   print('$value img path is ready');
            //   return value;
            // });
            //  setState(() {
            //
            //  });
          },
          tooltip: 'Increment',
          child: Icon(Icons.add)
          // Image.file("/data/user/0/com.example.caching_images/app_flutter/cached_images/fileName.png"),
          ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
