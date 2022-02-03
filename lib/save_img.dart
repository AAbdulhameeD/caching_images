import 'dart:async';
import 'dart:io' as Io;
import 'package:image/image.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SaveFile {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<Io.File> getImageFromNetwork(String url) async {
   // Io.HttpOverrides.global = MyHttpOverrides();

    Io.File file = await DefaultCacheManager().getSingleFile(url).then((value) {
      print('${      value.uri} uri');
    }).catchError((e){
      print('$e error in getImageFromNetwork');
    });

    return file;
  }

  Future<String> saveImage(String url) async {
   // Io.HttpOverrides.global = MyHttpOverrides();

   try{
     final file = await getImageFromNetwork(url);
     print('${     file.path} downloaded file path');

     //retrieve local path for device
    var path = await _localPath;
    Image image = decodeImage(file.readAsBytesSync());

    Image thumbnail = copyResize(image,height: 50,width: 50);
    var img =  Io.File('$path/11_22.png')..writeAsBytesSync(encodePng(thumbnail));
    // Save the thumbnail as a PNG.
    return    img.path;

   }catch(e){
     print('${e.toString()}');
     return 'error in saving the image';
   }
  }
}