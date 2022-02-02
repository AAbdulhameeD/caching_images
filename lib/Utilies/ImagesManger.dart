import 'dart:io';

import 'package:caching_images/Utilies/FileManger.dart';
import 'package:flutter/material.dart';

import 'DownloadImagesManger.dart';

class ImagesManger {
  ImageProvider loadImage(
      {@required String url,
      @required int type,
      @required int appId,
      @required int moduleId,
      @required String screenType,
      @required int businessTypeId}) {

    final imageName = FileManger()
        .getImageName(type, appId, moduleId, screenType, businessTypeId);

    DownloadImagesManger().downloadImage(
      url: url,
      downloadedImageName: imageName,
    );
    if (FileManger().isInLocal(imageName)) {
      return FileImage(File(imageName));
    } else {
      return NetworkImage(url);
    }
  }
}
