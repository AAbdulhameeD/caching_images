import 'dart:io';
import 'package:caching_images/Shared/constants/constants.dart';
import 'package:caching_images/Utilies/FileManger.dart';
import 'package:flutter/material.dart';
import 'DownloadImagesManger.dart';

class ImagesManger {

  FileManager fileManager;

  ImageProvider loadImage(
      {@required String url,
      @required int type,
      @required int appId,
      @required int moduleId,
      @required String screenType,
      @required int businessTypeId}) {

    fileManager = FileManager();

    final imageName = fileManager
        .getImageName(type, appId, moduleId, screenType, businessTypeId);

    DownloadImagesManger().downloadImage(
      url: url,
      downloadedImageName: imageName,
    );
    print('${fileManager.isInLocal(imageName)} is in local');
    if (fileManager.isInLocal(imageName)) {
      return FileImage(File('$globalFilePath/$imageName'));
    } else {
      return NetworkImage(url);
    }
  }
}
