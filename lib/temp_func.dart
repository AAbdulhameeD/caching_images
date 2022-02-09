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

enum ImageNameFormat {
  TYPE,
  TYPE_APPID,
  TYPE_APPID_MODULEID,
  TYPE_APPID_BUSSINESS_TID_SCREENTYPE
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
  var folderPath = '';

  ImageModel imgModel = ImageModel(
      appId: 1111,
      businessTypeID: 1211,
      imgType: 115,
      moduleId: 515,
      screenType: 'asda',
      imgUrl:
      "https://png.pngitem.com/pimgs/s/466-4661960_transpaart-serbian-kids.png");
  String filePath;

  List<ImageModel> list = [];

  //done
//Hamdy .. consider naming
  Io.File isDbContainsUrl(
      List<ImageModel> list, ImageModel newModel, imgNameFormat) {
    print('${list.length} list.length');
    //Hamdy .. directory must not be separated in like database manager and mut not be passed between functions
    bool isInLocal = DownloadImage().isInLocal(
        "${newModel.getImageName("png", imgNameFormat)}", folderPath);
    print('$isInLocal is in local');
    if (list.isEmpty && !isInLocal) {
      print('iam here');

      //Hamdy .. separate this in new functiond
      DownloadImage()
          .downloadImage(
          url: newModel.imgUrl,
          fileName: newModel.getImageName('png', imgNameFormat))
          .then((value) {
        print('downloaded');
      });
//Hamdy .. unneeded logic, remove it
      if (newModel.isInDB == false) {
        newModel.isInDB = true;
        dbManager.insertImageIntoDB(newModel).then((value) {}).catchError((e) {
          newModel.isInDB = false;
        });
      }
      //Hamdy .. how it will be returned and you still download it
      return Io.File(
          '$folderPath/${newModel.getImageName('png', imgNameFormat)}');

      // setState(() {
      //   newModel.isInDB = true;
      // });
      //Hamdy .. needs to be reconstructed
    } else {
      for (var item in list) {
        print('${item.appId} appid');
        if (newModel.imgUrl == item.imgUrl) {
          //TODO check image in local Storage, if it's not exists download it
          bool isInLocal = DownloadImage().isInLocal(
              "${item.getImageName("png", imgNameFormat)}", folderPath);
          print(isInLocal);
          if (isInLocal == false) {
            DownloadImage()
                .downloadImage(
                url: newModel.imgUrl,
                fileName: "${item.getImageName("png", imgNameFormat)}")
                .then((value) {
              print('downloaded');
            });
          }
          // setState(() {
          //   item.isInDB = true;
          // });
        } else {
          //TODO download the img and insert the model in DB
          DownloadImage()
              .downloadImage(
              url: newModel.imgUrl,
              fileName: "${item.getImageName("png", imgNameFormat)}")
              .then((value) {
            print('downloadedddddddd');
          });
          // setState(() {
          //   item.isInDB = false;
          // });
          if (item.isInDB == false) {
            item.isInDB = true;
            dbManager.updateImageByType(newModel).then((value) {
              print(item.imgUrl);
              print('is in db');
            }).catchError((e) {
              item.isInDB = false;
            });
          }
        }
        return Io.File(
            '$folderPath/${item.getImageName('png', imgNameFormat)}');
      }
    }
    return Io.File(
        '$folderPath/${newModel.getImageName('png', imgNameFormat)}');
  }

  List<ImageModel> imgTypeList = [];

  void getImageByType(ImageModel imgModel) {
    dbManager.getImageByType(imgModel.imgType).then((value) async {
      for (var i = 0; i < value.length; i++) {
        imgTypeList.add(ImageModel.fromJson(value[i]));
        await isDbContainsUrl(imgTypeList, imgModel, ImageNameFormat.TYPE);
      }
    });
  }

  List<ImageModel> imgAppIdList = [];
  Completer completer = new Completer<List<ImageModel>>();

  Future<Io.File> getImageByAppId(ImageModel imgModel) async {
    await dbManager.getImageByAppId(imgModel.appId).then((value) {
      for (var i = 0; i < value.length; i++) {
        //var d=completer.complete(value[i]);
        //Hamdy .. consider naming ... we write code for any image not for app image
        imgAppIdList.add(ImageModel.fromJson(value[i]));
        //completer.complete(imgAppIdList);
      }
    });
    return isDbContainsUrl(imgAppIdList, imgModel, ImageNameFormat.TYPE_APPID);

// isDbContainsUrl(imgAppIdList, imgModel, ImageNameFormat.TYPE_APPID);

    // if(imgModel.isInDB &&folderPath.isNotEmpty){
    //     //   return Io.File('$folderPath/${imgModel.getImageName('png', ImageNameFormat.TYPE_APPID)}');
    //     // }else{
    //     //   return Io.File('$folderPath/11_22.png');
    //     //
    //     // }
  }

  Io.File getImageByAppIdd(ImageModel imgModel) {
    var completed = false;
    while (!completed) {
      dbManager.getImageByAppId(imgModel.appId).then((value) {
        for (var i = 0; i < value.length; i++) {
          //var d=completer.complete(value[i]);
          imgAppIdList.add(ImageModel.fromJson(value[i]));
        }
        completed = true;
      }).catchError((e) {
        completed = false;
      });
    }

    return completed == true
        ? isDbContainsUrl(imgAppIdList, imgModel, ImageNameFormat.TYPE_APPID)
        : Io.File('$folderPath/15_111.png');
  }

  List<ImageModel> imgModelAndAppIdList = [];

  void getImageByModuleIdAndAppId(ImageModel imgModel) {
    dbManager
        .getImageByModuleAndAppId(
      imgModel.moduleId,
      imgModel.appId,
    )
        .then((value) async {
      for (var i = 0; i < value.length; i++) {
        imgModelAndAppIdList.add(ImageModel.fromJson(value[i]));
        await isDbContainsUrl(imgModelAndAppIdList, imgModel,
            ImageNameFormat.TYPE_APPID_MODULEID);
      }
    });
  }

  List<ImageModel> imgScreenAndBusinessIdList = [];

  void getImageByScreenTypeAndBusinessId(ImageModel imgModel) {
    dbManager
        .getImageByScreenTypeAndBusinessId(
        imgModel.appId, imgModel.screenType, imgModel.businessTypeID)
        .then((value) async {
      for (var i = 0; i < value.length; i++) {
        imgScreenAndBusinessIdList.add(ImageModel.fromJson(value[i]));
        await isDbContainsUrl(imgScreenAndBusinessIdList, imgModel,
            ImageNameFormat.TYPE_APPID_BUSSINESS_TID_SCREENTYPE);
      }
    });
  }

  void getLocalImage(ImageModel model) async {
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
        .getImageByModuleAndAppId(model.moduleId, model.appId)
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
      //  await isDbContainsUrl( list, model);
      //   print('${img.isInDB} is in Db ?');
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    folderPath = await getFilePathString();
  }

  Io.File data;

  getdata() async {
    data = await getImageByAppId(imgModel);
  }

  @override
  void initState() {
    super.initState();

    //Hamdy ..  write this in separated function
    Future.delayed(const Duration(milliseconds: 0), () async {
      globalFilePath = await FileManager().getCashedImagesFolderPath();

      // folderPath = await getFilePathString();
    });
  }

//await dbManager.insertImageIntoDB('http://asd', 1, 3, 5, 10, 8);

  Future<String> getFilePathString() async {
    return await DownloadImage().getFilePath();
  }

  Io.File getUiImage(String imgName) {
    try {
      if (DownloadImage().isInLocal('$imgName', folderPath)) {
        return Io.File('$folderPath/$imgName');
      } else {
        return Io.File('$folderPath/28-11.PNG');
      }
      print('$folderPath folder path contains image?  ');
    } catch (e) {
      print('$e');
      return Io.File('$folderPath/28-11.PNG');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Io.File file = getUiImage(imgModel.getImageName('png'));

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
                image: ImagesManager().loadImage(
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
          onPressed: () async {
            // getLocalImage(imgModel);
            setState(() {});
          },
          tooltip: 'Increment',
          child: Icon(Icons.add)
        // Image.file("/data/user/0/com.example.caching_images/app_flutter/cached_images/fileName.png"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
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
