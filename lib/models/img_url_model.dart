import 'dart:convert';

class ImgUrlModel{
  String splashBackground;
  String loginBackground;
  ImgUrlModel({this.splashBackground,this.loginBackground});
  factory ImgUrlModel.fromJson(Map<String,dynamic> json){
    return ImgUrlModel(
      loginBackground: json['loginBackGround'],
      splashBackground: json['splashBackGround']
    );
  }
  Map<String, dynamic> toJson() => {
    "loginBackGround ": loginBackground,
    "splashBackGround": splashBackground,
  };

}
class EncodeAndDecodeImg {
  static String encodeImgUrl(ImgUrlModel appData) {
    String data = json.encode(appData.toJson());
    //AppSharedPrefs().putAppData('app_data', data);
    return data;
  }
  static ImgUrlModel decodeImgUrl(String appCustomSettings) {
    return ImgUrlModel.fromJson(json.decode(appCustomSettings));
  }
}