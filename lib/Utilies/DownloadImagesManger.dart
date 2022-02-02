import 'dart:io';
import 'package:caching_images/Shared/constants/constants.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DownloadImagesManger {
  Future<void> downloadImage({
    @required String url,
    @required String downloadedImageName,
  }) async {

    try {
      Dio dio = new Dio();
      _httpClient(dio);
      final filePath = '$globalFilePath/$downloadedImageName';
      print('$globalFilePath global file path');
      Response response = await _getResponse(dio, url);
      print(response.headers);
      File file = File(filePath);
      var randomAccessFile = file.openSync(mode: FileMode.write);
      print(response.data);
      randomAccessFile.writeFromSync(response.data);
      await randomAccessFile.close();
      //      .download(url, filePath ).then((value) {
      //   print('${value} downloadImage response ');
      // }).catchError((e){
      //   print('$e downloadImage error ');
      //
      // });
    } catch (e) {
      print('${e.toString()} error in download');
    }
  }

  Future<Response> _getResponse(Dio dio, String url) async {
    return await dio.get(
      url,
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
  }

  void _httpClient(Dio dio) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }
}
