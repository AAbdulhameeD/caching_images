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
//
//   Future<Database> createDatabase() async {
//     String path = join(await getDatabasesPath(), 'properties.db');
//     print('path : $path');
//     _db = await openDatabase(path, version: 1, onCreate: (Database db, int v) {
//       // create tables
//       db.execute('''CREATE TABLE screens_properties (id integer ,
//           template integer , record_type integer , properties TEXT  )
//           ''');
//     });
//
//     return _db;
//   } // end createDatabase()
//
//
// /*  Future<void> insertProperty(MobileTheme mobileTheme) async {
//     Database db = await database;
//
//     await db.rawInsert(
//         '''insert into screens_properties(id , template ,record_type , properties)
//           values( ${mobileTheme.id} , ${mobileTheme.template} , ${mobileTheme.recordType} ,
//            '${mobileTheme.property}')''');
//   } */ // end insertNote()
//   Future<void> insertProperty(
//       int id, int template, int recordType, String property) async {
//     Database db = await database;
//
//     await db.rawInsert(
//         '''insert into screens_properties(id , template ,record_type , properties)
//           values( ${id} , ${template} , ${recordType} ,
//            '${property}')''');
//   }// end insertProperty()
//
//
//   Future<void> deleteAllData() async {
//     Database db = await database;
//     await db.delete('screens_properties');
//   } // deleteAllData()
//
//   Future<List> getAllProperties() async {
//     Database db = await database;
//     return await db.rawQuery('select * from screens_properties  ');
//   } // end getAllProperties()
//
// /*  Future<List> getProperty(int id) async {
//     Database db = await database;
//     list = await db.rawQuery('select * from screens_properties where id = $id');
//     print('list in get property  : $list');
//     return list;
//   } // end getProperty()*/
//   Future<List> _getProperty(int id, int template, int recordType) async {
//     Database db = await database;
//     list = await db.rawQuery(
//         'select * from screens_properties where id = $id AND template = $template AND record_type = $recordType ');
//     print('list in get property  : $list');
//     return list;
//   } // end getProperty()
//
//   Future<String> getRecord(int id, int template, int recordType) async {
//     List list = await _getProperty(id, template, recordType);
//     if (list.isEmpty) {
//       return null;
//     }
//     return list[0]['properties'];
//   } // end getRecord()
//
//   Future<void> updateProperty(MobileTheme mobileTheme) async {
//     Database db = await database;
//     try {
//       ///////////////, template = ? , record_type = ?
//       //  getProperty(mobileTheme.id , mobileTheme.template , mobileTheme.recordType);
//       int updatedRecord = await db.rawUpdate('''
//     update screens_properties
//     set properties = ?  , template = ?  , record_type = ?
//     where id = ? AND template = ? AND record_type = ?   ''', [
//         '${mobileTheme.property}',
//         mobileTheme.template,
//         mobileTheme.recordType,
//         mobileTheme.id,
//         mobileTheme.template,
//         mobileTheme.recordType
//       ]);
//       if (updatedRecord == 0) {
//         await insertProperty(mobileTheme.id, mobileTheme.template,
//             mobileTheme.recordType, mobileTheme.property);
//         print('this record is not exit');
//       }
//     } catch (e) {
//       print('e : ${e.toString()}');
//     }
//   }

  Future<Database> createImagesDatabase() async {
    String path = join(await getDatabasesPath(), 'images1.db');
    print('path : $path');
    _imagesDB = await openDatabase(path, version: 1, onCreate: (Database db, int v)async {
      // create tables
      await  db.execute('''CREATE TABLE images_caching (url TEXT , type  integer UNIQUE ,
           app_id  integer UNIQUE, module_id   integer UNIQUE,  screen_type TEXT UNIQUE, business_type_id  integer UNIQUE  )
          ''');
    });
    return _imagesDB;
  }

  Future<void> insertImageIntoDB(
      ImageModel imageModel) async {
    Database db = await imagesDB;

    try   {
      await db.rawInsert(
        '''insert into images_caching( url ,type , app_id ,module_id ,  screen_type, business_type_id ) 
          VALUES (
           '${imageModel.imgUrl}',
           ${imageModel.imgType} ,
           ${imageModel.appId} ,
           ${imageModel.moduleId},
          ' ${imageModel.screenType}',
           ${imageModel.businessTypeID} )''');}
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

  Future<List<dynamic>> getImageByType(int type) async {
    Database db = await imagesDB;
    try {List<dynamic> img =await db.rawQuery(
        'select * from images_caching where type = $type ');
    return img;
    }catch(e) {
      print('e : ${e.toString()}');
      return [];
    }
  }
  Future<List<dynamic>> getImageByAppId(int appId) async {
    Database db = await imagesDB;
    try {List<dynamic> img =await db.rawQuery(
        'select * from images_caching where app_id = $appId ');
    return img;
    }catch(e) {
      print('e : ${e.toString()}');
      return [];
    }
  }

  Future<List<dynamic>> getImageByModuleIdAndAppId(int moduleId,int appId) async {
    Database db = await imagesDB;
    try {List<dynamic> img =await db.rawQuery(
        'select * from images_caching where module_id = $moduleId AND app_id=$appId');
    return img;
    }catch(e) {
      print('e : ${e.toString()}');
      return [];
    }
  }

  Future<List<dynamic>> getImageByScreenTypeAndBusinessId(int appId,String screenType, int businessTypeId) async {
    Database db = await imagesDB;
    try {List<dynamic> img =await db.rawQuery(
        'select * from images_caching where  app_id = $appId AND screen_type=$screenType AND business_type_id=$businessTypeId');
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