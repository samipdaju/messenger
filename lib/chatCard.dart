import 'package:flutter/material.dart';

import 'constants.dart';
import 'model/chatmodel.dart';

class ChatCard extends StatelessWidget {
  ChatCard({
    required this.chats,
    required this.onPress,
  });

  final Chats chats;

  VoidCallback onPress;

  getMessage() {
    int count = 0;
    for (int i = chats.messages.length -1; i > 0; i--) {
      if (chats.messages[i].isSender== false) {
        count++;
      }
      if (chats.messages[i].isSender) {
        break;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onPress,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(chats.imageUrl),
                    ),
                    chats.isActive
                        ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: chats.isActive
                                ? KprimaryColor
                                : KsecondaryColor,
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor)),
                      ),
                    )
                        : Container(),



                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chats.name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Opacity(
                              opacity: 0.64,
                              child: Text(
                                "${chats.messages[chats.messages.length - 1].text} "
                                //
                                ,
                                style: TextStyle(
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 15,),
                        getMessage()!=0?

                        CircleAvatar(
                          radius: 10,
                          backgroundColor: KprimaryColor,
                          child: Text(
                            getMessage().toString(),
                            style: TextStyle(
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                        )
                            :SizedBox()
                      ],
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [

                        Opacity(opacity: 0.64, child: Text(chats.time)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),


      ],
    );
  }
}
