import 'dart:io';
import 'package:caching_images/DB/DBManger.dart';
import 'package:caching_images/models/image_model.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/constants.dart';

class DownloadImage {
  DBManager dbManager;
  DownloadImage(){
    dbManager  = DBManager();
  }

    Future<void>  downloadFile(url,{ImageModel imageModel}) async {

    var list = await dbManager.getImageByType(PROFILE_lOGO);
    print('$list listtt');
    if (list.isNotEmpty) {
      var imgModel = ImageModel.fromJson(list[0]);
      var fileName =
          '${imgModel.imgType}_${imgModel.appId}_${imgModel.moduleId}_${imgModel.screenType}_${imgModel.businessTypeID}.png';
      if (imgModel.imgUrl.compareTo(url) == 0) {
        //TODO download the image if the url is in DB but image file doesn't exists in local storage
      } else {
        String savePath = await getFilePath(fileName);
        Dio dio = Dio();

        dio.download(
          url,
          savePath,
        //  deleteOnError: true,
        ).then((_) {
          imageModel.imgUrl=url;
          dbManager.updateImageByType(imageModel);
        });
      }
    }else{
      dbManager.insertImageIntoDB(imageModel);

    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir = await getApplicationDocumentsDirectory();
    //await File( '${dir.path}/images').create().then((value) => print(value.path));

    final folderName = "cached_images";
    final folderPath = Directory('${dir.path}/$folderName');
    if ((await folderPath.exists())) {
      print("exist");
      folderPath.create().then((value) => print(value.path));
      return '${folderPath.path}/$uniqueFileName';
    } else {
      print("not exist");
      folderPath.create().then((value) => print(value.path));

      path = '${folderPath.path}/$uniqueFileName';

      return path;
    }
  }
}
