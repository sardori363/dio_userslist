import 'dart:convert';
import 'package:http/http.dart';
import 'package:dio/dio.dart';

class NetworkService {

  // baseUrl
  static String url = 'https://65a77f0b94c2c5762da6cd3a.mockapi.io/product';


  // headers
  static Map<String, String>? headers = {
    'Content-Type': 'application/json',
  };

  //methods
  static Future<String> GET() async {
    Dio dio = Dio();
    final response = await dio.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonEncode(response.data);
    }else{
      return '\nError occurred on Status Code ${response.statusCode}\n';
    }
  }

    static Future<String> POST(Map<String, dynamic> body)async{
    Uri uri = Uri.parse(url);
    var response = await post(uri, body: jsonEncode(body), headers: headers);
    print(uri);
    print(response.body);
    if(response.statusCode == 200 || response.statusCode == 201){
      return response.body;
    }else{
      return "Error statusCode of ${response.statusCode}";
    }
  }

static Future<String> PUT(Map<String, dynamic> body, String id)async{
    Uri uri = Uri.parse("$url/$id");
    var response = await put(uri, headers: headers, body: jsonEncode(body));
    print(uri);
    print(response.body);
    if(response.statusCode == 200 || response.statusCode == 201){
      return response.statusCode.toString();
    }else{
      return "Error statusCode of ${response.statusCode}";
    }
  }


static Future<String> DELETE(String id)async{
    Uri uri = Uri.parse("$url/$id");
    var response = await delete(uri);
    if(response.statusCode == 200 || response.statusCode == 201){
      return response.statusCode.toString();
    }else{
      return "Error statusCode of ${response.statusCode}";
    }
  }

  /// params
  static Map<String, String> emptyParams() => <String, String>{};

  /// body
  static Map<String, dynamic> bodyEmpty() => <String, dynamic>{};
}