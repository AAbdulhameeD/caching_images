import 'package:http/http.dart' as http;

class HttpHelper {
static  Future<http.Response> getData(String url)async {
    return  await http.get(url);
  }}