import 'package:flutter/material.dart';

import '../widgets/chat_messages.dart';
import '../widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  final String channelName;
  final String userIdentifier;
  const ChatScreen({super.key,required this.channelName,required this.userIdentifier});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child:  Scaffold(
        body: Column(
          children: [
            Expanded(child: ChatMessages(channelName: channelName,userIdentifier: userIdentifier,)),
            NewMessage(channelName: channelName,userIdentifier: userIdentifier,)
          ],
        ),
      ),
    );
  }
}