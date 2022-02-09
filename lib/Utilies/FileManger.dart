import 'dart:io';
import 'package:caching_images/Shared/constants/constants.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
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
  }

//done
  bool isInLocal(String fileName) {
    if (globalFilePath.isNotEmpty) {
      final imagesDirectory = Directory('$globalFilePath');
     // print('in is in local $globalFilePath');
      var images = imagesDirectory.listSync(recursive: true, followLinks: false);
      for (var image in images) {
       // print('${ _substringImagePath(image)==fileName} substring');
        if (fileName == _substringImagePath(image.toString())) {
          return true;
        }
      }
    }
    return false;
  }

  String _substringImagePath(String imagePath) {
    return imagePath.substring(
        imagePath.lastIndexOf('/') + 1,
        imagePath.length - 1);
  }
//ignore:unnecessary_statements
  String getImageName(int type, int appId, int moduleId, String screenType,
      int businessTypeId) {
    switch (type) {
      case PROFILE_LOGO:
        return 'PROFILE_LOGO.png';
      case LOGIN_BACKGROUND:
        return 'LOGIN_BACKGROUND.png';
      case LOGIN_LOGO:
        return 'LOGIN_LOGO.png';
      case MODULES:
        return 'MODULES_${appId}_$moduleId.png';
      case APPS:
        return 'APPS_$appId.png';
      case SCREENS:
        return 'SCREENS_${appId}_${businessTypeId}_$screenType.png';
    }
  }
}
