import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:untitled6/model/constants.dart';
import 'package:untitled6/firebase/database.dart';
import '../../constants.dart';
import '../detailedMessage/detailedmessage.dart';
import '../loggingin/login.dart';
import '../../model/chatmodel.dart';
import '../../model/message.dart';
import '../../widgets/fillinbutton.dart';
import 'package:intl/intl.dart';

import '../../chatCard.dart';

class Body extends StatefulWidget {
  var userSnapshot;
  var userChatSnapshot;
  int selectedIndex;

  Body(this.userSnapshot, this.userChatSnapshot, this.selectedIndex);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool show = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  update(id, data) async {
    await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(id)
        .update(data);
  }

  getUserInfo() async {}

  @override
  Widget build(BuildContext context) {
    List screens = [
      Container(),
      Container(),
    ];
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            color: KprimaryColor,
            child: Row(
              children: [
                FillInButton(text: "Recent Messages", onPress: () {}),
                SizedBox(
                  width: 20,
                ),
                FillInButton(
                  text: "Active",
                  onPress: () {},
                  isFilled: false,
                ),
              ],
            ),
          ),
          widget.userSnapshot != null
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: widget.userSnapshot,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                itemBuilder: (context, position) {
                                  var message = snapshot.data?.docs[position];
                                  var history;
                                  var imageHistory;

                                  getImageSnapshot() async {
                                    QuerySnapshot<Map<String, dynamic>>
                                        imageSnapshot = await FirebaseDatabase()
                                            .getUserByEmail(getName(
                                                a: message!["email"],
                                                constant: Constants.email));
                                    imageHistory = imageSnapshot;

                                    return imageSnapshot;
                                  }

                                  return StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("ChatRoom")
                                          .doc(message!["email"])
                                          .collection("chats")
                                          .orderBy("time")
                                          .snapshots(),
                                      builder: (context, snapshot2) {
                                        return !snapshot2.hasData
                                            ? shimmerWidget(2)
                                            : (snapshot2.data?.docs.length)! !=
                                                    0
                                                ? StreamBuilder<
                                                        QuerySnapshot<
                                                            Map<String,
                                                                dynamic>>>(
                                                    stream: getImageSnapshot()
                                                        .asStream(),
                                                    builder:
                                                        (context, snapshot3) {
                                                      return snapshot3.hasData
                                                          ? Stack(
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    var id = getChatRoomId(
                                                                        getName(
                                                                            a: message[
                                                                                "email"],
                                                                            constant: Constants
                                                                                .email),
                                                                        Constants
                                                                            .email);

                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) => DetailedMessage(
                                                                                name: snapshot3.data?.docs[0]["name"],
                                                                                email: snapshot3.data?.docs[0]["email"],
                                                                                imageUrl: snapshot3.data?.docs[0]["imageUrl"],
                                                                                id: id)));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            20),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Stack(
                                                                          children: [
                                                                            snapshot3.data?.docs[0]["imageUrl"] == ""
                                                                                ? CircleAvatar(
                                                                                    radius: 30,
                                                                                    child: Text(
                                                                                      snapshot3.data?.docs[0]["name"][0],
                                                                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                    ),
                                                                                    backgroundColor: Kcolors[Random().nextInt(4)],
                                                                                  )
                                                                                : CircleAvatar(
                                                                                    backgroundImage: NetworkImage(snapshot3.data?.docs[0]["imageUrl"]),
                                                                                    radius: 30,
                                                                                  ),
                                                                            Positioned(
                                                                              right: 0,
                                                                              bottom: 0,
                                                                              child: Container(
                                                                                height: 20,
                                                                                width: 20,
                                                                                decoration: BoxDecoration(shape: BoxShape.circle, color: KprimaryColor, border: Border.all(width: 4, color: Theme.of(context).scaffoldBackgroundColor)),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Flexible(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    snapshot3.data?.docs[0]["name"],
                                                                                    // getName(a: message["name"], constant: Constants.name),
                                                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: DateTime.now().day != (DateTime.parse((snapshot2.data?.docs[(snapshot2.data?.docs.length)! - 1]["time"])!.toDate().toString())).day ? 0 : 10,
                                                                                  ),
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Flexible(
                                                                                        child: Opacity(
                                                                                            opacity: 0.64,
                                                                                            child: Text(
                                                                                              snapshot2.data?.docs[(snapshot2.data?.docs.length)! - 1]["sendBy"] != Constants.email
                                                                                                  ? snapshot2.data?.docs[(snapshot2.data?.docs.length)! - 1]["type"] == "image"
                                                                                                      ? "Sent a photo"
                                                                                                      : snapshot2.data?.docs[(snapshot2.data?.docs.length)! - 1]["message"]
                                                                                                  : "You: ${snapshot2.data?.docs[(snapshot2.data?.docs.length)! - 1]["type"] == "image"
                                                                                                  ? "Sent a photo"
                                                                                                  : snapshot2.data?.docs[(snapshot2.data?.docs.length)! - 1]["message"]}",
                                                                                              style: TextStyle(
                                                                                                fontSize: 16,
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                              ),
                                                                                            )),
                                                                                      ),
                                                                                      Opacity(
                                                                                        opacity: 0.64,
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                          children: [
                                                                                            DateTime.now().day != (DateTime.parse((snapshot2.data?.docs[(snapshot2.data?.docs.length)! - 1]["time"])!.toDate().toString())).day
                                                                                                ? Text(
                                                                                                    DateFormat.MMMd().format(DateTime.parse((snapshot2.data?.docs[(snapshot2.data?.docs.length)! - 1]["time"])!.toDate().toString())),
                                                                                                    style: TextStyle(fontSize: 10),
                                                                                                  )
                                                                                                : SizedBox(),
                                                                                            Text(
                                                                                              DateFormat.Hm().format(DateTime.parse((snapshot2.data?.docs[(snapshot2.data?.docs.length)! - 1]["time"])!.toDate().toString())),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  onLongPress:
                                                                      () {
                                                                    showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return Container(
                                                                            height: MediaQuery.of(context).size.height *
                                                                                1 /
                                                                                3,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                ListTile(
                                                                                    title: Text(" Delete Conversation"),
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              title: Text("Delete Conversation with ${getName(a: message["name"], constant: Constants.name)}"),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                  onPressed: () async {
                                                                                                    Navigator.pop(context);
                                                                                                    var data = {};
                                                                                                    await FirebaseDatabase().deleteConversation(message["email"], data);
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    "Yes",
                                                                                                    style: TextStyle(fontSize: 18),
                                                                                                  ),
                                                                                                ),
                                                                                                TextButton(
                                                                                                  onPressed: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    "NO",
                                                                                                    style: TextStyle(fontSize: 18),
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          });
                                                                                    })
                                                                              ],
                                                                            ),
                                                                          );
                                                                        });
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                          : Container();
                                                    })
                                                : Container();
                                      });
                                },
                                itemCount: snapshot.data!.docs.length,
                              )
                            : shimmerWidget(3);
                      }))
              : Container()
        ],
      ),
    );
  }
}

class shimmerWidget extends StatelessWidget {
  shimmerWidget(this.length);

  late int length;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 20.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        Container(
                          width: 200,
                          height: 15.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
