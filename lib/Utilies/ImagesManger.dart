import 'dart:io';
import 'package:caching_images/Shared/constants/constants.dart';
import 'package:caching_images/Utilies/FileManger.dart';
import 'package:flutter/material.dart';
import 'DownloadImagesManger.dart';

class ImagesManager {
  FileManager fileManager;

  ImagesManager(){fileManager = FileManager();}

//Hamdy .. remove required option and make nonrequired optional with default value empty or null
  //done
  ImageProvider loadImage(
      {@required String url,
      @required int type,
      int appId,
      int moduleId,
      String screenType = '',
      int businessTypeId}) {

    final imageName = fileManager.getImageName(
        type, appId, moduleId, screenType, businessTypeId);


      DownloadImagesManger().downloadImage(
        url: url,
        downloadedImageName: imageName,
      );


    print('${fileManager.isInLocal(imageName)} is in local');
      return fileManager.isInLocal(imageName)
          ? FileImage(File('$globalFilePath/$imageName'))
          : NetworkImage(url);
    }

  Future getFilePath () async{
    globalFilePath = await FileManager().getCashedImagesFolderPath();

  }
}
