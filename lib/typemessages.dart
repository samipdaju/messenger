import 'package:flutter/material.dart';
import 'textMessage.dart';

import 'constants.dart';
import 'model/chatmodel.dart';
import 'model/message.dart';
class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
    required this.chats,
  }) : super(key: key);

  final  message;
  final Chats chats;

  @override
  Widget build(BuildContext context) {
    messageContent( message) {
      switch (message["type"]) {
        case "ChatMessageTye.text":
          return TextMessage(message: message);
          break;
        case "ChatMessageTye.audio":
          return AudioMessage(
            message: message,
          );
        case "ChatMessageTye.video":
          return VideoMessage(
            message: message,
          );
          break;
        default:
          return SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        message["isSender"] ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message["isSender"]) ...[
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(chats.imageUrl),
            ),
            SizedBox(
              width: 10,
            ),
          ],
          SizedBox(height: 5),
          Flexible(child: TextMessage(message:message,)),
          if (message["isSender"])
            Column(
              children: [
                MessageStatusDot(
                  message: message,
                  messageStatus: message["status"],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class AudioMessage extends StatelessWidget {
  final  message;

  AudioMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color:
        message.isSender ? KprimaryColor : KprimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Icon(
            Icons.play_arrow_rounded,
            color: message.isSender ? Colors.white : KprimaryColor,
          ),
          Expanded(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: !message.isSender
                        ? KprimaryColor.withOpacity(0.4)
                        : Colors.white70,
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: !message.isSender ? KprimaryColor : Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              "0:37",
              style: TextStyle(
                  fontSize: 12,
                  color: !message.isSender
                      ? KprimaryColor.withOpacity(0.7)
                      : Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class VideoMessage extends StatelessWidget {
  var message;

  VideoMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.45,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/samip.jpg",
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KprimaryColor,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.play_arrow_rounded,
                ),
                iconSize: 30,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
   final message;
  final String messageStatus;

  MessageStatusDot({required this.message, required this.messageStatus});

  @override
  Widget build(BuildContext context) {
    dotColor( status) {
      switch (status) {
        case "MessageStatus.viewed":
          return KprimaryColor;
          break;
        case "MessageStatus.not_viewed":
          return Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.5);
          break;
        case "MessageStatus.not_sent":
          return kErrorColor;
          break;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: 5),
      height: 12,
      width: 12,
      decoration:
      BoxDecoration(shape: BoxShape.circle, color: dotColor(messageStatus)),
      child: Icon(
        messageStatus == "MessageStatus.not_sent" ? Icons.close : Icons.done,
        color: Theme.of(context).scaffoldBackgroundColor,
        size: 10,
      ),
    );
  }
}
