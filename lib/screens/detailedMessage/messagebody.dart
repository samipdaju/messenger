import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled6/firebase/database.dart';
import 'package:untitled6/model/constants.dart';
import '../../constants.dart';

// import '../../model/constants.dart';
import '../../model/message.dart';
import '../../textMessage.dart';
import 'package:provider/provider.dart';
import '../../model/apimodel.dart';
import '../../typemessages.dart';
import 'package:dio/dio.dart' ;
import '../../model/chatmodel.dart';
import '../../model/statemanagement/messagemodel.dart';

class MessageBody extends StatefulWidget {
  final String id;
  final String imageUrl;

  MessageBody(this.id, this.imageUrl);

  @override
  State<MessageBody> createState() => _MessageBodyState();
}

class _MessageBodyState extends State<MessageBody> {
  sendMessage(messageMap, map) async {
    var value = await FirebaseDatabase().addMessages(widget.id, messageMap);
    await FirebaseDatabase().addLastMessage(widget.id, map);
  }


  requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future saveFile(String link, String fileName) async {
    Directory directory;

      if (await requestPermission(Permission.storage)) {
        directory = (await getExternalStorageDirectory())!;

        String newpath = "";
        List folders = directory.path.split("/");
        for (int i = 1; i < folders.length; i++) {
          String folder = folders[i];
          if (folder != "Android") {
            newpath += "/" + folder;
          } else {
            break;
          }
        }
        newpath = newpath + "/SamipMessagingApp";
        directory = Directory(newpath);
        print(directory.path);
      } else {
        return false;
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + "/$fileName");

        await Dio().download(link, saveFile.path,
            onReceiveProgress: (downloaded, totalSize) {

            });


    }

    return false;
  }

  var messageSnapshot = null;

  late Chats chats;
  String text = "";
  String downloadUrl = "";
  final TextEditingController fieldText = TextEditingController();

  @override
  void initState() {
    // chats = widget.chats;
    getInfo();

    // TODO: implement initState
    super.initState();
  }

  void addItemToList() {
    setState(() {});
  }

  File? fileImage;

  pickImage(source) async {
    var images = await ImagePicker.platform.pickImage(source: source);

    setState(() {
      fileImage = File(images!.path);
      print(fileImage!.path.toString());
      print("hi");
    });
  }

  uploadImage() async {
    final ref = await FirebaseStorage.instance
        .ref("messageFiles/${fileImage!.path.toString()}");

    var result = ref.putFile(fileImage!);

    setState(() {});

    if (result == null) return;

    final snapshot = await result;

    downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {});
    print('Download-Link: $downloadUrl');

    return downloadUrl;
  }

  getInfo() async {
    messageSnapshot = await FirebaseDatabase().seeMessage(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
              alignment: Alignment.bottomCenter,
              child: messageSnapshot != null
                  ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: messageSnapshot,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                reverse: true,
                                itemBuilder: (context, position) {
                                  var list = snapshot.data?.docs;
                                  var reversedList =
                                      new List.from(list!.reversed);

                                  var message = reversedList[position];
                                  bool isSender =
                                      message["sendBy"] == Constants.email;
                                  bool lowerSame = ((reversedList[position == 0
                                          ? position
                                          : position - 1]["sendBy"] ==
                                      message["sendBy"]));
                                  bool lowerNotSame = ((reversedList[
                                          position == 0
                                              ? position
                                              : position - 1]["sendBy"] !=
                                      message["sendBy"]));
                                  bool upperNotSame = ((reversedList[position ==
                                              (snapshot.data?.docs.length)! - 1
                                          ? position
                                          : position + 1]["sendBy"] !=
                                      message["sendBy"]));

                                  bool upperSame = ((reversedList[position ==
                                              (snapshot.data?.docs.length)! - 1
                                          ? position
                                          : position + 1]["sendBy"] ==
                                      message["sendBy"]));

                                  // bool upperDeleted = ((reversedList[position ==
                                  //             (snapshot.data?.docs.length)! - 1
                                  //         ? position
                                  //         : position + 1]["hideFor"]
                                  //     .contains(message["sendBy"])));
                                  //
                                  // bool lowerDeleted = ((reversedList[
                                  //         position == 0
                                  //             ? position
                                  //             : position - 1]["hideFor"]
                                  //     .contains(message["sendBy"])));

                                  bool lowest = (position == 0);
                                  bool highest = (position ==
                                      (snapshot.data?.docs.length)! - 1);

                                  bool pads = ((lowerNotSame && upperNotSame) ||
                                          (lowest && upperNotSame)) ||
                                      (highest && lowerNotSame);

                                  bool pad = ((highest &&
                                          message["sendBy"] !=
                                              Constants.email) ||
                                      (lowerNotSame) && upperNotSame ||
                                      (lowerSame) && upperNotSame);

                                  return GestureDetector(
                                    onLongPress: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [

                                                      message["type"] ==
                                                          "image"? ListTile(
                                                      leading: Icon(
                                                        Icons.download_sharp,
                                                        color: KprimaryColor,
                                                      ),
                                                      title: Text(
                                                          "Save Image "),
                                                      onTap: ()async {
                                                        Navigator.pop(context);
                                                        await saveFile(message["message"], message["message"]);
                                                        showmessage("Downloaded");

                                                      }):SizedBox(),
                                                  ListTile(
                                                      leading: Icon(
                                                        Icons.delete,
                                                        color: KprimaryColor,
                                                      ),
                                                      title: Text(
                                                          "Delete for you"),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Delete this message"),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                      await FirebaseDatabase().deleteChat(
                                                                          widget
                                                                              .id,
                                                                          snapshot
                                                                              .data
                                                                              ?.docs[(snapshot.data?.docs.length)! - 1 - position]
                                                                              .id);
                                                                    },
                                                                    child: Text(
                                                                      "Yes",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      "NO",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      }),
                                                  isSender &&
                                                          message["message"] !=
                                                              "Unsent the message"
                                                      ? ListTile(
                                                          leading: Icon(
                                                            Icons
                                                                .delete_forever_sharp,
                                                            color:
                                                                KprimaryColor,
                                                          ),
                                                          title: Text(
                                                              "Remove for all"),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Remove The Message"),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                          await FirebaseDatabase().removeChat(
                                                                              widget.id,
                                                                              snapshot.data?.docs[(snapshot.data?.docs.length)! - 1 - position].id);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Yes",
                                                                          style:
                                                                              TextStyle(fontSize: 18),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "NO",
                                                                          style:
                                                                              TextStyle(fontSize: 18),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                          })
                                                      : SizedBox(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ReactionButton(
                                                          message["reaction"] ==
                                                                  "👍"
                                                              ? ""
                                                              : "👍",
                                                          "👍",
                                                          widget.id,
                                                          (snapshot
                                                              .data
                                                              ?.docs[(snapshot
                                                                      .data
                                                                      ?.docs
                                                                      .length)! -
                                                                  1 -
                                                                  position]
                                                              .id)!,
                                                          message["reaction"] ==
                                                              "👍"
                                                              ? KprimaryColor:Colors.black),
                                                      ReactionButton(
                                                          message["reaction"] ==
                                                                  "❤"
                                                              ? ""
                                                              : "❤",
                                                          "❤",
                                                          widget.id,
                                                          (snapshot
                                                              .data
                                                              ?.docs[(snapshot
                                                                      .data
                                                                      ?.docs
                                                                      .length)! -
                                                                  1 -
                                                                  position]
                                                              .id)!,message["reaction"] ==
                                                          "❤"
                                                          ? KprimaryColor:Colors.black),
                                                      ReactionButton(
                                                          message["reaction"] ==
                                                                  "😂"
                                                              ? ""
                                                              : "😂",
                                                          "😂",
                                                          widget.id,
                                                          (snapshot
                                                              .data
                                                              ?.docs[(snapshot
                                                                      .data
                                                                      ?.docs
                                                                      .length)! -
                                                                  1 -
                                                                  position]
                                                              .id)!,
                                                          message["reaction"] ==
                                                              "😂"
                                                              ? KprimaryColor:Colors.black)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          });

                                      print(position);
                                      print((snapshot.data?.docs.length));
                                      // print(pads);

                                      print(upperSame);
                                      print(lowerSame);
                                      print(lowest);
                                    },
                                    child: Padding(
                                        padding: pads
                                            ? const EdgeInsets.only(top: 15)
                                            : const EdgeInsets.only(top: 5),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment: isSender
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                            children: [
                                              if (message["sendBy"] !=
                                                  Constants.email) ...[
                                                pad
                                                    ? CircleAvatar(
                                                        radius: 22,
                                                        backgroundImage:
                                                            NetworkImage(getImage(
                                                                a: widget
                                                                    .imageUrl,
                                                                constant: Constants
                                                                    .imageUrl)),
                                                      )
                                                    : const SizedBox(width: 44),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                              const SizedBox(height: 5),
                                              Flexible(
                                                child: Stack(
                                                  children: [
                                                    message["type"] == "image"
                                                        ? Container(

                                                            constraints:
                                                                BoxConstraints(
                                                                    maxHeight:
                                                                        300,
                                                                    minHeight:
                                                                        200,
                                                                    minWidth:
                                                                        200),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color:Colors.grey.withOpacity(0.3),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            child: ClipRRect(
                                                                child: message[
                                                                            "message"] ==
                                                                        ""
                                                                    ? Stack(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        children: [
                                                                          Opacity(
                                                                              opacity: 0.3,
                                                                              child: fileImage != null
                                                                                  ? Image.file(
                                                                                      fileImage!,
                                                                                      fit: BoxFit.cover,
                                                                                    )
                                                                                  : CircularProgressIndicator()),
                                                                          CircularProgressIndicator(),
                                                                        ],
                                                                      )
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              new MaterialPageRoute(builder: (BuildContext context) {
                                                                            return new Scaffold(
                                                                              appBar: AppBar(
                                                                                automaticallyImplyLeading: false,
                                                                                title: BackButton(
                                                                                  color: KprimaryColor,
                                                                                ),

                                                                                backgroundColor: Colors.transparent,

                                                                                elevation: 0

                                                                                ,

                                                                                centerTitle: false,
                                                                              ),
                                                                              body: SafeArea(

                                                                                child: Center(
                                                                                  child: new Hero(
                                                                                    tag: message["message"],
                                                                                    child: ClipRect(
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(30),
                                                                                        ),
                                                                                        child: new Image(
                                                                                          image: new NetworkImage(message["message"]),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }));
                                                                        },
                                                                        child: Hero(
                                                                          tag:message["message"],
                                                                          child: Image
                                                                              .network(
                                                                            message[
                                                                                "message"],
                                                                            fit: BoxFit
                                                                                .cover,
                                                                            errorBuilder: (context,
                                                                                error,
                                                                                stackTrace) {
                                                                              return Container(
                                                                                padding: EdgeInsets.all(20),
                                                                                alignment: Alignment.center,
                                                                                child: const Text(
                                                                                  'Whoops! \n Looks like Image not found',
                                                                                  style: TextStyle(fontSize: 20),
                                                                                ),
                                                                              );
                                                                            },
                                                                            loadingBuilder: (BuildContext context,
                                                                                Widget child,
                                                                                ImageChunkEvent? loadingProgress) {
                                                                              if (loadingProgress ==
                                                                                  null)
                                                                                return child;
                                                                              return Center(
                                                                                child: Container(
                                                                                  height: 250,
                                                                                  width: 250,
                                                                                  child: Center(
                                                                                    child: CircularProgressIndicator(
                                                                                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            margin: isSender
                                                                ? const EdgeInsets
                                                                        .only(
                                                                    left: 25)
                                                                : const EdgeInsets
                                                                        .only(
                                                                    right: 15),
                                                          )
                                                        : Container(
                                                            margin: isSender
                                                                ? const EdgeInsets
                                                                        .only(
                                                                    left: 25)
                                                                : const EdgeInsets
                                                                        .only(
                                                                    right: 15),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        20),
                                                            child: Text(
                                                              message[
                                                                  "message"],
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: isSender
                                                                    ? Colors
                                                                        .white
                                                                    : Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyText1
                                                                        ?.color,
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius: pads
                                                                    ? BorderRadius.circular(40)
                                                                    : isSender
                                                                        ? BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(40),
                                                                            bottomLeft:
                                                                                Radius.circular(40),
                                                                            topRight: highest || upperNotSame
                                                                                ? Radius.circular(40)
                                                                                : Radius.circular(15),
                                                                            bottomRight: lowest || lowerNotSame
                                                                                ? Radius.circular(40)
                                                                                : upperNotSame || highest
                                                                                    ? Radius.circular(0)
                                                                                    : Radius.circular(15),
                                                                          )
                                                                        : BorderRadius.only(
                                                                            topRight: Radius.circular(40),
                                                                            bottomLeft: lowest || lowerNotSame
                                                                                ? Radius.circular(40)
                                                                                : upperNotSame || highest
                                                                                    ? Radius.circular(0)
                                                                                    : Radius.circular(15),
                                                                            bottomRight: Radius.circular(40),
                                                                            topLeft: highest || upperNotSame ? Radius.circular(40) : Radius.circular(15)),
                                                                color: message["message"] != "Unsent the message" ? KprimaryColor.withOpacity(isSender ? 1 : 0.1) : Colors.grey),
                                                          ),
                                                    isSender
                                                        ? Positioned(
                                                            child: message[
                                                                        "reaction"] !=
                                                                    ""
                                                                ? Container(
                                                              padding:EdgeInsets.all(8),
                                                                   decoration:BoxDecoration(
                                                                     color: Colors.grey.withOpacity(0.8),
                                                                     shape: BoxShape.circle,
                                                                     
                                                                   ),
                                                                    child: Text(
                                                                      message["reaction"] ==
                                                                              "❤"
                                                                          ? "❤"
                                                                          : message["reaction"] == "😂"
                                                                              ? "😂"
                                                                              : "👍",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                            left: 10,
                                                            bottom: 0,
                                                          )
                                                        : Positioned(
                                                            child: message[
                                                                        "reaction"] !=
                                                                    ""
                                                                ? Container(
                                                              padding:EdgeInsets.all(8),
                                                              decoration:BoxDecoration(
                                                                color: Colors.grey.withOpacity(0.8),
                                                                shape: BoxShape.circle,

                                                              ),
                                                                    child: Text(
                                                                      message["reaction"] ==
                                                                              "❤"
                                                                          ? "❤"
                                                                          : message["reaction"] == "😂"
                                                                              ? "😂"
                                                                              : "👍",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                            right: 0,
                                                            bottom: 0,
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ])),
                                  );
                                },
                                itemCount: snapshot.data?.docs.length,
                              )
                            : Container();
                      })
                  : Container()),
        )),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 32,
                color: Colors.green.withOpacity(0.03),
              ),
            ],
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Consumer<MessageModel>(builder: (context, message, child) {
            return Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic),
                  color: KprimaryColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 50,
                    decoration: BoxDecoration(
                      color: KprimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sentiment_satisfied_alt_outlined,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.color
                              ?.withOpacity(0.64),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                          controller: fieldText,
                          onChanged: (value) {
                            setState(() {
                              text = value;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write a message",
                          ),
                        )),
                        text != ""
                            ? InkWell(
                                child: const Icon(Icons.send),
                                onTap: () async {
                                  Map<String, dynamic> messageMap = {
                                    "message": fieldText.text,
                                    "sendBy": Constants.email,
                                    "time": DateTime.now(),
                                    "reaction": "",
                                    "type": "text",
                                    "hideFor": []
                                  };
                                  Map<String, dynamic> map = {
                                    "lastMessage": fieldText.text,
                                    "lastMessageTime": DateTime.now()
                                  };

                                  setState(() {
                                    fieldText.clear();
                                    text = "";
                                  });
                                  await sendMessage(messageMap, map);
                                },
                              )
                            : Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Map<String, dynamic> messageMap = {
                                        "message": downloadUrl,
                                        "sendBy": Constants.email,
                                        "time": DateTime.now(),
                                        "reaction": "",
                                        "type": "image",
                                        "hideFor": []
                                      };
                                      Map<String, dynamic> map = {
                                        "lastMessage": fieldText.text,
                                        "lastMessageTime": DateTime.now()
                                      };

                                      await pickImage(ImageSource.gallery);
                                      await sendMessage(messageMap, map);
                                      await uploadImage();
                                      await FirebaseDatabase()
                                          .updateImage(widget.id, downloadUrl);
                                      downloadUrl = "";
                                    },
                                    child: Icon(
                                      Icons.attach_file,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color
                                          ?.withOpacity(0.64),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Map<String, dynamic> messageMap = {
                                        "message": downloadUrl,
                                        "sendBy": Constants.email,
                                        "time": DateTime.now(),
                                        "reaction": "",
                                        "type": "image",
                                        "hideFor": []
                                      };
                                      Map<String, dynamic> map = {
                                        "lastMessage": fieldText.text,
                                        "lastMessageTime": DateTime.now()
                                      };

                                      await pickImage(ImageSource.camera);
                                      await sendMessage(messageMap, map);
                                      await uploadImage();
                                      await FirebaseDatabase()
                                          .updateImage(widget.id, downloadUrl);
                                      downloadUrl = "";

                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color
                                          ?.withOpacity(0.64),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        )
      ],
    );
  }
}

class TileOptions extends StatelessWidget {
  TileOptions({
    Key? key,
    required this.onPressl,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  String title;
  var onPressl;
  String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.delete,
          color: KprimaryColor,
        ),
        title: Text(title),
        onTap: () {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(subtitle),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await onPressl;
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
        });
  }
}

class ReactionButton extends StatelessWidget {
  final String title;
  final String id;
  final String ids;
  final String emoji;
  Color color;

  ReactionButton(this.title, this.emoji, this.id, this.ids,this.color);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        await FirebaseDatabase().addReaction(id, ids, title);
      },
      child: Container(

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                offset: Offset(2, 2),
              ),
            ]),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: Text(
            emoji,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
