import 'package:caching_images/models/image_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  static final DBManager _instance = DBManager.internal();

  factory DBManager() => _instance;
  DBManager.internal();

 // Database _db;
  Database _imagesDB;
  List list;

  //Future<Database> get database async => _db ?? await createDatabase();
  Future<Database> get imagesDB async => _imagesDB ?? await createImagesDatabase();

  Future<Database> createImagesDatabase() async {
    String path = join(await getDatabasesPath(), 'images1.db');
    print('path : $path');
    _imagesDB = await openDatabase(path, version: 1, onCreate: (Database db, int version)async {
      // create tables
      await  db.execute('''CREATE TABLE images_caching (url TEXT , type  integer UNIQUE ,
           app_id  integer UNIQUE, module_id  integer UNIQUE, screen_type TEXT UNIQUE, business_type_id  integer UNIQUE  )
          ''');
    });
    return _imagesDB;
  }

  Future<void> insertImageIntoDB(
      ImageModel imageModel) async {
    Database db = await imagesDB;

    try   {
      await db.rawInsert(
        '''insert into images_caching( url ,type , app_id ,module_id , screen_type, business_type_id ) 
          VALUES (
           '${imageModel.imgUrl}',
           ${imageModel.imgType} ,
           ${imageModel.appId} ,
           ${imageModel.moduleId},
          '${imageModel.screenType}',
           ${imageModel.businessTypeID} )''',);}
           catch(e) {
      print('insert error : ${e.toString()}');
    }
  }

  Future<void> updateImageByType(
     ImageModel imageModel)async{
    Database db = await imagesDB;
    try{
      await db.rawUpdate('''
    update images_caching 
    set url = ?  ,
    type = ?  ,
    app_id = ?, 
    module_id = ?,
    screen_type = ?,
    business_type_id = ?
    where type = ? ''', [
        imageModel.imgUrl,
        imageModel.imgType,
        imageModel.appId,
        imageModel.moduleId,
        imageModel.screenType,
        imageModel.businessTypeID,
        imageModel.imgType,

      ]);
    }catch(e) {
      print('e : ${e.toString()}');
    }

  }

  Future<void> deleteAllImages() async {
    Database db = await imagesDB;
    await db.delete('images_caching');
  }

  Future<List<Map<String,dynamic>>> getImageByType(int type) async {
    Database db = await imagesDB;
    try {
      List<dynamic> img =await db.rawQuery(
        'select * from images_caching where type = $type ');
    return img;
    }catch(e) {
      print('e : ${e.toString()}');
      return [];
    }
  }
  Future<List<Map<String,dynamic>>> getImageByAppId(int appId) async {
    Database db = await imagesDB;
    try {List<dynamic> img =await db.rawQuery(
        'select * from images_caching where app_id = $appId ');
    return img;
    }catch(e) {
      print('e : ${e.toString()}');
      return [];
    }
  }

  Future<List<Map<String,dynamic>>> getImageByModuleAndAppId(int moduleId,int appId) async {
    Database db = await imagesDB;
    try {List<dynamic> img =await db.rawQuery(
        'select * from images_caching where module_id = $moduleId AND app_id=$appId');
    return img;
    }catch(e) {
      print('e : ${e.toString()}');
      return [];
    }
  }

  Future<List<Map<String,dynamic>>> getImageByScreenTypeAndBusinessId(int appId,String screenType, int businessTypeId) async {
    Database db = await imagesDB;
    try {List<dynamic> img =await db.rawQuery(
        'select * from images_caching where  app_id = $appId AND screen_type= "$screenType" AND business_type_id=$businessTypeId');
    return img;
    }catch(e) {
      print('e : ${e.toString()}');
      return [];
    }
  }
  //
  // Future<List<dynamic>> getImageByBusinessTypeId(int businessTypeId) async {
  //   Database db = await imagesDB;
  //   try {List<dynamic> img =await db.rawQuery(
  //       'select * from images_caching where business_type_id = $businessTypeId ');
  //   return img;
  //   }catch(e) {
  //     print('e : ${e.toString()}');
  //     return [];
  //   }
  // }

}