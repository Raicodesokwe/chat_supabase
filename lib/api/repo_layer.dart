import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/initialise_supabase_model.dart';
import '../services/network_service.dart';
import '../utils/api_status.dart';
import '../utils/constants.dart';

class RepoService{
  
 static Future<Object> initializeSupabase()async{
 
       try {
  var url =   Uri.https(initializeSupabaseUrl,'/initialize_supabase');
    log("INITIALIZE SUPABASE : ");
      Response response = await NetworkServices.get(url: url);
        log("RESPONSE INITIALIZE SUPABASE${response.statusCode}: ${response.body.toString()}");
       if (successCodes.contains(response.statusCode)) {
     final initializeSupabaseResponse= InitializeSupabaseModel.fromJson(json.decode(response.body));
        Supabase.initialize(
      url: initializeSupabaseResponse.supabaseUrl!,
      anonKey: initializeSupabaseResponse.apiKey!,
    );
        return Success(
          code: successCode,
          response: initializeSupabaseResponse,
        );
      } else {
        
        return Failure(
          code: unknownError,
          errorResponse: jsonDecode(response.body)['error'],
        );
      }
} on Exception catch (e) {
      
      log(e.toString());
      return Failure(code: unknownError, errorResponse: somethingWentWrong);
}

 
  }
 

}