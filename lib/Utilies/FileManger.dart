import 'dart:io';

import 'package:caching_images/Shared/constants/constants.dart';
import 'package:path_provider/path_provider.dart';

class FileManger {
  Directory _appDirectory;
  String _folderName = 'cached_images';
  String _path = '';

  Future<String> getCashedImagesFolderPath() async {
    _appDirectory = await getApplicationDocumentsDirectory();
    final cashedImagesFolderPath = Directory(
        '${_appDirectory.path}/$_folderName');

    await cashedImagesFolderPath.exists()
        ? _path = cashedImagesFolderPath.path
        : cashedImagesFolderPath.create();
    _path = cashedImagesFolderPath.path;
    return _path;
    /* if ((await cashedImagesFolderPath.exists())) {
      print('Cashed images folder exists ${cashedImagesFolderPath.path}');
      _path = '${cashedImagesFolderPath.path}';
    } else {
      print('Cashed images folder doesn\'t exist');
      cashedImagesFolderPath.create().then((value) => print('now the folder exists ${value.path}'));
      _path = '${cashedImagesFolderPath.path}';
    }*/
    // return _path;
  }

//done
  bool isInLocal(String fileName) {
 /*   if (globalFilePath.isNotEmpty) {
      final imagesDirectory = Directory('$globalFilePath');
      //Hamdy .. there is no need for list. it will be always one file
      List<String> imagesTitles = [];
      String imageName = '';
      imagesDirectory
          .listSync(recursive: true, followLinks: false)
          .forEach((image) {
        if (fileName == _substringImagePath(image.toString()){
        return true;
        }
        // String imageName = _substringImagePath(image.toString());
        // imagesTitles.add(imageName);
        // print(imageName);
        });
      return imagesTitles.contains(fileName);
    } else {
      throw ('the directory is wrong');
    }*/
    if (globalFilePath.isNotEmpty) {
      final imagesDirectory = Directory('$globalFilePath');
      //Hamdy .. there is no need for list. it will be always one file
      var imagesDirIterated = imagesDirectory
          .listSync(recursive: true, followLinks: false);
      for (var image in imagesDirIterated) {
        if (fileName == _substringImagePath(image.toString())) {
          return true;
        }
      }
    }
    return false;
  }

  String _substringImagePath(String imagePath) {
    return imagePath.toString().substring(
        imagePath.toString().lastIndexOf('/') + 1,
        imagePath.toString().length - 1);
  }

  String getImageName(int type, int appId, int moduleId, String screenType,
      int businessTypeId) {
    String _imgName = '';
    switch (type) {
      case PROFILE_LOGO:
        _imgName = 'PROFILE_LOGO';
        break;
      case LOGIN_BACKGROUND:
        _imgName = 'LOGIN_BACKGROUND';
        break;
      case LOGIN_LOGO:
        _imgName = 'LOGIN_LOGO';
        break;
      case MODULES:
        _imgName = 'MODULES_${appId}_$moduleId';
        break;
      case APPS:
        _imgName = 'APPS_$appId';
        break;
      case SCREENS:
        _imgName = 'SCREENS_${appId}_${businessTypeId}_$screenType';
        break;
    }
    return _imgName;
  }
}
