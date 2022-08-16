import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'constants.dart';
import 'model/message.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final  ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: message.isSender?EdgeInsets.only(left: 25):EdgeInsets.only(right: 15),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(

        message.text,

        style: TextStyle(
          fontSize: 18,

          color: message.isSender
              ? Colors.white
              : Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: KprimaryColor.withOpacity(message.isSender ? 1 : 0.1)),
    );
  }
}
