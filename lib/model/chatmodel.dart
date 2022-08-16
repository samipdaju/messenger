import 'package:flutter/cupertino.dart';
import 'message.dart';

class Chats with ChangeNotifier{

  var name;
  var time;
  var imageUrl;
  var isActive;
  List  messages;

  Chats({this.name, this.imageUrl, required this.messages, this.isActive, this.time});
}

List<Chats> chats = [
  Chats(name: "Kshitiz Paudel", imageUrl: "assets/kshitiz.jpg", messages:kshitiz, isActive:false,
    time: "3 min ago",),
  Chats(
      name: "Samip Paudel", imageUrl: "assets/samip.jpg",messages:samip, isActive:true, time: "3 min ago"),
  Chats(name: "Sunil Paudel", imageUrl: "assets/sonu.jpg",messages:sunil, isActive:false,
      time: "3 min ago"),
  Chats(name: "Rakskhya Devkota", imageUrl: "assets/rakshya.jpg", messages:rakshya, isActive:false,
      time:"3 min ago"),
];


List<ChatMessage> kshitiz = [
  ChatMessage(text: "Hello K xa ho ",
      status: MessageStatus.viewed,
      isSender: true,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "Sab thik xa yar ",
      status: MessageStatus.viewed,
      isSender: false,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "Kaile aune ho",
      status: MessageStatus.viewed,
      isSender: false,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "Thaxaina ni",
      status: MessageStatus.not_viewed,
      isSender: false,
      messageType: ChatMessageTye.text
  ),
];

List<ChatMessage> samip = [
  ChatMessage(text: "k gardai ho k xa ani ",
      status: MessageStatus.viewed,
      isSender: true,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "Kei thik xaina aile ta ",
      status: MessageStatus.viewed,
      isSender: false,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "K vo ra testo huh",
      status: MessageStatus.viewed,
      isSender: true,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "Corona ni",
      status: MessageStatus.viewed,
      isSender: false,
      messageType: ChatMessageTye.video
  ),
];
List<ChatMessage> sunil = [
  ChatMessage(text: "Hello K xa ho ",
      status: MessageStatus.viewed,
      isSender: true,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "Sab thik xa yar ",
      status: MessageStatus.viewed,
      isSender: false,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "khai tyo astiko ",
      status: MessageStatus.viewed,
      isSender: true,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "vaxo prajapati",
      status: MessageStatus.viewed,
      isSender: false,
      messageType: ChatMessageTye.audio
  ),
  ChatMessage(text: "haha vaxo",
      status: MessageStatus.not_viewed,
      isSender: true,
      messageType: ChatMessageTye.text
  ),
];
List<ChatMessage> rakshya = [
  ChatMessage(text: "Hello K xa ho ",
      status: MessageStatus.viewed,
      isSender: false,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "Sab thik xa yar ",
      status: MessageStatus.viewed,
      isSender: true,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "Mar ta",
      status: MessageStatus.viewed,
      isSender: false,
      messageType: ChatMessageTye.text
  ),
  ChatMessage(text: "Sent a video",
      status: MessageStatus.not_viewed,
      isSender: true,
      messageType: ChatMessageTye.video
  ),
];

