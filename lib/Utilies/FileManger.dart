import 'dart:io';

import 'package:caching_images/Shared/constants/constants.dart';
import 'package:path_provider/path_provider.dart';

class FileManger {
  Directory _appDirectory;
  String _folderName = 'cached_images';
  String _path = '';

  Future<String> getFilePath() async {
    _appDirectory = await getApplicationDocumentsDirectory();
    final folderPath = Directory('${_appDirectory.path}/$_folderName');
    if ((await folderPath.exists())) {
      print(folderPath.path);
      _path = '${folderPath.path}';
    } else {
      folderPath.create().then((value) => print(value.path));
      _path = '${folderPath.path}';
    }
    return _path;
  }

//done
  bool isInLocal(String fileName) {
    if (globalFilePath.isNotEmpty) {
      final imagesDirectory = Directory('$globalFilePath');
      //Hamdy .. there is no need for list. it will be always one file
      List<String> imagesTitles = [];
      imagesDirectory
          .listSync(recursive: true, followLinks: false)
          .forEach((image) {
        String imageName = _substringImagePath(image.toString());
        imagesTitles.add(imageName);
        // print(imageName);
      });
      return imagesTitles.contains(fileName);
    } else {
      throw ('the directory is wrong');
    }
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
