import 'package:flutter/material.dart';

enum ChatMessageTye { text, audio, video, image }
enum MessageStatus { not_sent, not_viewed, viewed }

class ChatMessage with ChangeNotifier{
  final String text;
  final  messageType;
  final  status;
  final bool isSender;

  ChatMessage(
      {required this.text,
      required this.status,
      required this.isSender,
      required this.messageType});
}

