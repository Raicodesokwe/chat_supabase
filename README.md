<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# chat_supabase - A Flutter Chat Package Using Supabase

`chat_supabase` is a powerful and easy-to-use chat package for Flutter applications, leveraging [Supabase](https://supabase.io/) for real-time messaging and data storage. This package allows developers to integrate chat functionality seamlessly with profile creation and message streaming.

## Features

Add chat functionality to your Flutter App quickly and seamlessly with only a few lines of code
- **Real-time Messaging**: Send and receive messages in real-time.
- **User Profile Creation**: Add a user profile identifier and avatar image for identification purposes.
- **Chat Channels**: Create chat groups via channel identifiers
- **Message Grouping**: Automatically groups messages by date for better readability.
- **Customizable UI**: Custom message bubbles with user avatars and timestamps.
- **Supabase Integration**: Uses Supabase's real-time database features for seamless data handling.

## Getting started

- Call the initializeChatSupabase() method in your App's Main method to initialize the package
- Create a user profile with the createChatUserProfile() preferably when signing up to create the user's profile. Pass the username, user image and the user's unique identifier to this method.
- Navigate to the ChatScreen() widget, passing the channel name and the user's unique identifier

## Usage

```dart
import 'dart:developer';
import 'dart:io';
import 'package:chat_supabase/chat_supabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibly/services/auth_service.dart';
import 'package:visibly/widgets/user_image_picker.dart';
import '../utils/common_functions.dart';
import '../utils/constants.dart';
import '../utils/navigation_utils.dart';
import '../widgets/common_button.dart';
import '../widgets/common_text_field.dart';
import 'home_screen.dart';
void main() async{
  // Initialize Supabase
await initializeChatSupabase();
  runApp(const MyApp());
}


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isLoading=false;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  // You can store form field values here
  String? _email;
  String? _password;
  String? _username;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         backgroundColor: AppColors.appDark,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
            UserImagePicker(onPickImage: (pickedImage){
_selectedImage=pickedImage;
                  },),
                  SizedBox(
                    height: screenHeight(context) * .06,
                  ), 
                  CommonTextField(
                    validator: (val)=>validateUserName(val),
                    hintText: 'Username',onChanged: (value){
              _username=value;
                 }),
                    SizedBox(
                    height: screenHeight(context) * .06,
                  ),
                _isLoading? const CommonButton(label: 'Loading...',
                    
                                  ) :GestureDetector(
                        onTap: ()async{
                          if(_selectedImage==null){
                            showToast('Please pick an image');
                          }
             else if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading=true;
                });
               
                        // You can proceed to sign the user in or perform another action
                       await AuthService.signUp(password: _password!,email: _email!,context: context);
                           final uid=FirebaseAuth.instance.currentUser!.uid;
                           await createChatUserProfile(userIdentifier: uid,username: _username!,selectedImage: _selectedImage!);  // Add condition to update where id matches the Firebase UID
      
setState(() {
                  _isLoading=false;
                });
                    Future.delayed(const Duration(seconds: 1));
  if(mounted){
    openReplaceScreen(context,const HomeScreen()); 
  }    

                      } else {
                        // If the form is not valid, do nothing or show an error
                        log('Form is not valid');
                      }
                  },
                    child:const CommonButton(label: 'Sign up',
                    
                                  ),
                  ),
                   
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.appDark,
          onPressed: (){
            openScreen(context, ChatScreen(channelName: 'mojito',userIdentifier: FirebaseAuth.instance.currentUser!.uid,));
          },
        child:const Icon(Icons.chat_rounded,color: AppColors.appGreen,),
        ),
        body: Container()
      ),
    );
  }
}
```

## Installation

Add the `chat_supabase` package to your `pubspec.yaml`
