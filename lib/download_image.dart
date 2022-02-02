import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

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
    try {
      Dio dio = new Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      //
      final filePath = '${await getFilePath()}/$fileName';
      //  print('file path $filePath');
      Response response = await dio.get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(filePath);
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

  void isSameImage(File file){
    List<int> img =[];
    var raf = file.openSync(mode: FileMode.write);
    raf.readIntoSync(img);

  }

  Future<String> getFilePath() async {
    String path = '';
    appDirectory = await getApplicationDocumentsDirectory();
    //await File( '${dir.path}/images').create().then((value) => print(value.path));

    try {
      final folderPath = Directory('${appDirectory.path}/$folderName');
      if ((await folderPath.exists())) {
        print("exist");
        print('existing folder ${folderPath.path}');
        //folderPath.create().then((value) => print(value.path));
        path = '${folderPath.path}';
      } else {
        print("not exist");
        folderPath.create().then((value) => print(value.path));
        path = '${folderPath.path}';
      }
      print('my path $path');
      return path;
    } catch (error) {
      print('no such file exists in dirs');
    }
  }
//done
  //Hamdy .. make file utils and move it out of download class
  bool isInLocal(String fileName, String directory) {
    // appDirectory = await getApplicationDocumentsDirectory();
   // if (directory.isNotEmpty) {
      final imagesDirectory = Directory('$directory');
      //Hamdy .. there is no need for list. it will be always one file
      List<String> imagesTitles = [];
      final contents =
          imagesDirectory.listSync(recursive: true, followLinks: false);
      contents.forEach((image) {
        String imageName = image.toString().substring(
            image.toString().lastIndexOf('/') + 1, image.toString().length - 1);
        //
        imagesTitles.add(imageName);
        // print(imageName);
      });
      return imagesTitles.contains(fileName);
  //  } else {
      throw ('the directory is wrong');
 //   }
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

  void deleteDirectory(String dirPath) {
    Directory dir = Directory(dirPath);
    if (!dir.existsSync()) {
      print('cached images not exist');
      return;
    }
    dir.deleteSync(recursive: true);
  }
}
