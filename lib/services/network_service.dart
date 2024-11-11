
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'error_handling.dart';

class NetworkServices{
 
  
  // GET
  static Future<Response> get({
    required Uri url,
  }) async {
    log("GET : $url");
        
    Response? response;
    try {
      response = await http.get(url);
    } on Exception catch (e) {
      log("RESPONSE CODE : $e");
    }
    
    log("RESPONSE CODE : ${response!.statusCode}");
    response = await ResponseHandling.handleResponse(response);
    return response;
  }
}