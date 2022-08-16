import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled6/constants.dart';
import 'package:untitled6/model/constants.dart';
import 'messagebody.dart';
import '../../model/chatmodel.dart';

class DetailedMessage extends StatefulWidget {
  final String name;
  final String email;
  final String imageUrl;
final String id;
  DetailedMessage(
      {required this.name, required this.email, required this.imageUrl,required this.id});

  @override
  State<DetailedMessage> createState() => _DetailedMessageState();
}

class _DetailedMessageState extends State<DetailedMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: MessageBody(widget.id,widget.imageUrl),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(
          ),
          getImage(a: widget.imageUrl,constant:  Constants.imageUrl) ==""?
          CircleAvatar(
           backgroundColor: Kcolors[Random().nextInt(4)],
          child: Text( getName(a:widget.name,constant: Constants.name)[0],
          style: TextStyle(
            color: Colors.white
          ),),
          ):
          CircleAvatar(
            backgroundImage: NetworkImage(getImage(a: widget.imageUrl,constant:  Constants.imageUrl)),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getName(a:widget.name,constant: Constants.name),
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  child: Text(
                   getName(a:widget.email,constant: Constants.email) ,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.local_phone)),
        IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
        SizedBox(

        )
      ],
    );
  }
}
