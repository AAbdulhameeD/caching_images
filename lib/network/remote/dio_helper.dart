import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper {
  static Dio dio;


  static init(String url) {
    dio = Dio(
      BaseOptions(
        baseUrl: '$url',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    @required String url,
    String lang = 'en',
    String token,
    Map<String, dynamic> queries,
  }) async {
    return await dio.get(url, queryParameters: queries);
  }

  static Future<Response> putData({
    @required String url,
    @required Map<String, dynamic> data,
    String lang = 'en',
    String token,
    Map<String, dynamic> queries,
  }) async {
    return await dio.post(url, queryParameters: queries, data: data);
  }

  static Future<Response> updateData({
    @required String url,
    @required Map<String, dynamic> data,
    String lang = 'en',
    String token,
    Map<String, dynamic> queries,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? '',
    };
    return await dio.put(url, queryParameters: queries, data: data);
  }
}
