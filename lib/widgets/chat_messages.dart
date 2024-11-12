
import 'dart:async';
import 'dart:developer';

import 'package:chat_supabase/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class ChatMessages extends StatefulWidget {
  final String channelName;
  final String userIdentifier;
  const ChatMessages({super.key, required this.channelName,required this.userIdentifier });

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  Stream<List<Map<String, dynamic>>>? _messageStream;
  @override
  void initState() {
    super.initState();
    _initializeStreamWithTimeout();
  }
    void _initializeStreamWithTimeout() {
    _messageStream = supabaseChat
        .stream(primaryKey: ['id'])
        .eq('channel', widget.channelName) // Filter by channel
        .order('created_at', ascending: true)
        .map((event) => event.map((e) => e).toList())
        .timeout(
          const Duration(days: 1000),
          onTimeout: (sink) {
            debugPrint('Stream connection timed out. Retrying...');
            // Close the sink to prevent further data from this stream
            sink.close();
            // Trigger a reconnection attempt by setting state
            _retryConnection();
          },
        );
  }

  void _retryConnection() {
    // Wait for a short duration before attempting to reconnect
    Future.delayed(const Duration(seconds: 5), () {
     if (mounted) {
      setState(() {
        _initializeStreamWithTimeout();
      });
    }
    });
  }
  @override
  void dispose() {
    super.dispose();
    supabase.removeAllChannels();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
  stream: _messageStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      log('Error: ${snapshot.error}');
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No messages available...'));
    }

    final messages = snapshot.data!;

    // Group messages by day
    final groupedMessages = <String, List<Map<String, dynamic>>>{};
    for (var message in messages) {
      final dateKey = DateFormat('yyyy-MM-dd').format(DateTime.parse(message['created_at']).toLocal());
      groupedMessages.putIfAbsent(dateKey, () => []).add(message);
    }
     // Sort the keys to ensure dates are processed from oldest to newest
        final sortedDateKeys = groupedMessages.keys.toList()..sort();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
      reverse: false,
      itemCount: sortedDateKeys.length,
      itemBuilder: (context, dayIndex) {
         // Get the date and messages for each day
            final dateKey = sortedDateKeys[dayIndex];
            final dayMessages = groupedMessages[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display date header at the top for each day
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(dateKey)),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
              ),
            ),
           // Display each message for that day in ascending order
                ...dayMessages.map((messageItem) {
                  final index = dayMessages.indexOf(messageItem);
                  final nextChatMessage = index + 1 < dayMessages.length ? dayMessages[index + 1] : null;

                  // Retrieve the user ID of the current and next messages
                  final currentMessageUserId = messageItem[userId];
                  final nextMessageUserId = nextChatMessage?[userId];
                  final nextUserIsSame = nextMessageUserId == currentMessageUserId;

                  final messageDate = DateTime.parse(messageItem[createdAt]).toLocal();

                  if (nextUserIsSame) {
                    return MessageBubble.next(
                      message: messageItem[message],
                      isMe: widget.userIdentifier == currentMessageUserId,
                      dateTime: messageDate,
                    );
                  } else {
                    return MessageBubble.first(
                      userImage: messageItem[avatarUrl],
                      username: messageItem[username],
                      message: messageItem[message],
                      isMe: widget.userIdentifier == currentMessageUserId,
                      dateTime: messageDate,
                    );
                  }
                }).toList(),
          ],
        );
      },
    );
  },
);


  }
}
