import '../main.dart';

class ImageModel{
  String imgUrl;
  int imgType;
  int appId;
  int moduleId;
  String screenType;
  int businessTypeID;
  bool isInDB=false;
  String get img=>'${imgUrl.toString()}';

  bool compare(String url){
    if(url.compareTo(imgUrl.toString())==0)
      {return true;}
    else
      return false;
  }

String getImageName(String extension, dynamic imgName){
    switch(imgName){
      case ImageNameFormat.TYPE:
        return '$imgType.$extension';
        break;
        case ImageNameFormat.TYPE_APPID:
        return '${imgType}_$appId.$extension';
        break;
        case ImageNameFormat.TYPE_APPID_MODULEID:
        return '${imgType}_${appId}_$moduleId.$extension';
        break;
        case ImageNameFormat.TYPE_APPID_BUSSINESS_TID_SCREENTYPE:
          return '${imgType}_${appId}_${moduleId}_$screenType.$extension';
        break;
      default :
        return  '$imgType.$extension';

    }
}

  ImageModel({this.imgUrl, this.imgType, this.appId, this.moduleId,
      this.screenType, this.businessTypeID,});
  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      ImageModel(
        imgUrl: json['url'],
        imgType: json['type'],
        appId:json['app_id'] ,
        moduleId: json['module_id'],
        screenType: json['screen_type'],
        businessTypeID:json['business_type_id'] ,
      );
  Map<String, dynamic> toJson() => {
    "url ": imgUrl,
    "type": imgType,
    "app_id": appId,
    "module_id": moduleId,
    "screen_type": screenType,
    "business_type_id": businessTypeID,
  };
}