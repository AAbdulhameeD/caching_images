import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

class DownloadImage {
  Directory appDirectory;
  final folderName = "cached_images";

  /*DBManager dbManager;
  DownloadImage() {
    dbManager = DBManager();
  }

  Future<void> downloadFile(
      {@required url,
      @required ImageModel imageModel,
      @required int imageType}) async {
    var list = await dbManager.getImageByType(imageType);
    print('$list listtt');
    if (list.isNotEmpty) {
      var imgModel = ImageModel.fromJson(list[0]);
      var fileName =
          '${imgModel.imgType}_${imgModel.appId}_${imgModel.moduleId}_${imgModel.screenType}_${imgModel.businessTypeID}.png';
      if (imgModel.imgUrl.compareTo(url) == 0) {
        //TODO download the image if the url is in DB but image file doesn't exists in local storage
      } else {
        _downloadImage(url: url, fileName: fileName).then((_) {
          imageModel.imgUrl = url;
          dbManager.updateImageByType(imageModel);
        });
      }
    } else {
      dbManager.insertImageIntoDB(imageModel);
    }
  }
*/
  Future<void> downloadImage({
    @required String url,
    @required String fileName,
  }) async {
    //HttpOverrides.global = MyHttpOverrides();
  // var cancelToken=CancelToken();

    try {
      Dio dio = new Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      //
      var appDir = await getApplicationDocumentsDirectory();
      String fullPath= '${appDir.path}/5565.jpg';
   //final filePath = await getFilePath(fileName);
    //  print('file path $filePath');
       Response response=await dio.get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      print(response.data);

      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();

      //      .download(url, filePath ).then((value) {
      //   print('${value} downloadImage response ');
      // }).catchError((e){
      //   print('$e downloadImage error ');
      //
      // });

    } catch (e) {
      print('${e.toString()} error in download');
    }
  }

  Future<String> getFilePath(String uniqueFileName) async {
    String path = '';
    appDirectory = await getApplicationDocumentsDirectory();
    //await File( '${dir.path}/images').create().then((value) => print(value.path));

    final folderPath = Directory('${appDirectory.path}/$folderName');
    if ((await folderPath.exists())) {
      print("exist");
      print(folderPath.path);
      //folderPath.create().then((value) => print(value.path));
      path = '${folderPath.path}/$uniqueFileName.png';
    } else {
      print("not exist");
      folderPath.create().then((value) => print(value.path));
      path = '${folderPath.path}/$uniqueFileName.png';
    }
    print('my path $path');
    return path;
  }

  Future<bool> isInLocal(String fileName) async {
    appDirectory = await getApplicationDocumentsDirectory();
    final imagesDirectory = Directory('${appDirectory.path}/$folderName');
    List<String> imagesTitles = [];
    final contents =
        imagesDirectory.listSync(recursive: true, followLinks: false);
    contents.forEach((image) {
      String imageName = image.toString().substring(
          image.toString().lastIndexOf('/') + 1, image.toString().length - 1);
      imagesTitles.add(imageName);
      print(imageName);
    });
    return imagesTitles.contains(fileName);
    // for (var fileOrDir in contents) {
    //   if (fileOrDir is File) {
    //     print(fileOrDir);
    //   } else if (fileOrDir is Directory) {
    //     print(fileOrDir.path);
    //   }
    // }

    /* List<FileSystemEntity> entities = await filePath.list().toList();
    entities.forEach(print);
    return entities.contains('1_login.png');*/
  }
}
