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

String getImageName(String extension){
    return '${imgType}_${appId}_${moduleId}_$screenType.$extension';
}

  ImageModel({this.imgUrl, this.imgType, this.appId, this.moduleId,
      this.screenType, this.businessTypeID,this.isInDB});
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