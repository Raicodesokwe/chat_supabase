
import 'package:http/http.dart' as http;
import '../utils/common_functions.dart';
import '../utils/constants.dart';

class ResponseHandling {
  static Future<http.Response> handleResponse(http.Response response) async {
    switch (response.statusCode) {
      case unauthorizedError:
        showToastMsg("UNAUTHORISED ACCESS");
        return response;
      case unknownError:
        showToastMsg("UNAUTHORISED ACCESS");
        return response;
      default:
        return response;
    }
  }
}
