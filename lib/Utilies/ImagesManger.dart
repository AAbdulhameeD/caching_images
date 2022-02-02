import 'dart:io';

import 'package:caching_images/Utilies/FileManger.dart';
import 'package:flutter/material.dart';

class ImagesManger {

  ImageProvider loadImage(String url, dynamic type) {
    if (FileManger().isInLocal('aa')) {
      return FileImage(File('as'));
    } else {
      return NetworkImage(url);
    }
  }
}
