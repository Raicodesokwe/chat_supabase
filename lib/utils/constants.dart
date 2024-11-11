//supabase
// It's handy to then extract the Supabase client in a variable for later uses
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final supabaseStorage= supabase.storage.from('profiles');
final supabaseChat=supabase.from('chat');
final supabaseProfiles=supabase.from('profiles');

//supabase chat table fields
const String avatarUrl='avatar_url';
const String username='username';
const String unknown='Unknown';
const String message='message';
const String createdAt='created_at';
const String chat='chat';
const String id='id';
const String userId='user_id';
const String channel='channel';
//general error message
const String somethingWentWrong='Something went wrong';
//Colors
class AppColors {
  static const appDark = Color(0xff292D32);
  static const appGreen = Color(0xFF64FF6A);
}
//initialize supabase
String initializeSupabaseUrl='supabasetwo-rmlzyqy-erick-murai.globeapp.dev';
//Request headers
Map<String, String> get headers {

  return {
    "Content-Type": "application/json",
  };
}

//Errors
const noInternet = 100;
const apiError = 101;
const unknownError = 103;
const emptyFieldError = 104;
const unauthorizedError = 401;

//success and failure codes
const successCode = 200;
const successCreated = 201;
const successCodes = [200, 201, 202, 204];
const failureCodes = [400, 401, 402, 404, 500, 503];