import 'dart:io';

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

    Dio dio = Dio();
    final filePath = await _getFilePath(fileName);
    //print('file path $filePath');
    await dio.download(url, filePath);
  }

  Future<String> _getFilePath(String uniqueFileName) async {
    String path = '';
    appDirectory = await getApplicationDocumentsDirectory();
    //await File( '${dir.path}/images').create().then((value) => print(value.path));

    final folderPath = Directory('${appDirectory.path}/$folderName');
    if ((await folderPath.exists())) {
      print("exist");
      print(folderPath.path);
      //folderPath.create().then((value) => print(value.path));
      path = '${folderPath.path}/$uniqueFileName';
    } else {
      print("not exist");
      folderPath.create().then((value) => print(value.path));
      path = '${folderPath.path}/$uniqueFileName';
    }
    print('my path $path');
    return path;
  }

  Future<bool> isInLocal(String fileName) async {
    appDirectory = await getApplicationDocumentsDirectory();
    final imagesDirectory = Directory('${appDirectory.path}/$folderName');
    List<String> imagesTitles = [];
    final contents = imagesDirectory.listSync(
        recursive: true, followLinks: false);
    contents.forEach((image) {
      String imageName = image.toString().substring(
          image.toString().lastIndexOf('/') + 1,
          image
              .toString()
              .length - 1);
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
