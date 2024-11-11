 import 'dart:io';

import 'package:chat_supabase/api/repo_layer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants.dart';

Future<void> createChatUserProfile({required String userIdentifier, required File selectedImage,required String username}) async {
     final imagePath='/$userIdentifier/profile';
    final imageExtension=selectedImage.path.split('.').last.toLowerCase();
     final imageBytes=await selectedImage.readAsBytes();
    await supabaseStorage.uploadBinary(imagePath, imageBytes,
    fileOptions: FileOptions(
     contentType: 'image/$imageExtension'
    )
    );
    final imageUrl=supabaseStorage.getPublicUrl(imagePath);
    // Perform the update with a where clause to match the correct profile
       await supabaseProfiles.insert({
                              'username':username,
                              'id':userIdentifier,
                              'avatar_url':imageUrl
                             })
          .eq('id', userIdentifier);  // Add condition to update where id matches the Firebase UID
  }
  //initialise supabase
  Future<void> initializeChatSupabase() async {
  await RepoService.initializeSupabase();
}
  //show toast
void showToastMsg(String message) {
  Fluttertoast.showToast(
      msg: message, // message
      toastLength: Toast.LENGTH_SHORT, // length
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey // location
      // timeInSecForIos: 1               // duration
      );
}