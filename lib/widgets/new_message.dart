
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class NewMessage extends StatefulWidget {
  final String channelName;
  final String userIdentifier;
  const NewMessage({super.key,required this.channelName ,required this.userIdentifier});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController _messageController= TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  void _submitMessage()async{
    final enteredMessage=_messageController.text;
    if(enteredMessage.trim().isEmpty){
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();
  // final uid=FirebaseAuth.instance.currentUser!.uid;
      // Query the Supabase 'profiles' table for the user profile data by UID
    final profileData = await supabaseProfiles
        .select()
        .eq(id, widget.userIdentifier)
        .single(); // .single() to fetch one record only
//send to supabase
await supabaseChat.insert({
                          userId:widget.userIdentifier,
                          username:profileData[username],
                          avatarUrl:profileData[avatarUrl],
                          message:enteredMessage,
                          channel:widget.channelName
                         })
      .eq(id, widget.userIdentifier);  // Add condition to update where id matches the Firebase UID
    
    
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(
      left: 15,
      right: 1,
      bottom: 14
    ),
    child: Row(
      children: [
        Expanded(child: TextField(
          controller: _messageController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration:const InputDecoration(
              labelText: 'Send a message...'
            ),
        )),
        IconButton(
          color: AppColors.appDark,
          onPressed: _submitMessage, icon:const Icon(Icons.send))
      ],
    ),
    );
  }
}