import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/constants.dart';
import 'package:untitled6/screens/detailedMessage/detailedmessage.dart';

import '../../firebase/database.dart';
import '../../model/constants.dart';

class SearchPages extends SearchDelegate {
  @override
  // TODO: implement searchFieldStyle

  TextStyle? get searchFieldStyle =>
      TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w200);

  @override
  // TODO: implement searchFieldDecorationTheme
  // TODO: implement searchFieldDecorationTheme

  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    assert(theme != null);
    return theme.copyWith(
        appBarTheme: AppBarTheme(
      backgroundColor: KprimaryColor,
    ));
  }

  @override
  // TODO: implement searchFieldLabel

  var history;
  void Function(int) onPress;
  var historySnapshot;
  var  userCheckSnapshot;
  int i = 0;

  SearchPages(
      this.history, this.onPress, this.historySnapshot, this.userCheckSnapshot);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  buildResults(BuildContext context) {

    return Container(
      child: Text(" "),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    createChatRoom(userName, email, imageUrl, idName) async {
      if (email != Constants.email) {
        Map<String, dynamic> map = {
          "name": getName(a: userName, constant: Constants.name),
          "email": getName(a: email, constant: Constants.email),
          "imageUrl": getImage(a: imageUrl, constant: Constants.imageUrl),
        };

        List<String> users = [
          getName(a: email, constant: Constants.email),
          Constants.email
        ];
        var id = getChatRoomId(idName, Constants.email);

        Map<String, dynamic> chatRoom = {
          "users": users,
          "chatRoomId": id,
          "name": userName,
          "email": email,
          "imageUrl": imageUrl,
          "users": users,
          "lastMessage": "",
          "lastMessageTime": ""
        };
        for (int j = 0; j < userCheckSnapshot.docs.length; j++) {
          print(j);
          print(userCheckSnapshot.docs.length);

          if (id == userCheckSnapshot.docs[j]["chatRoomId"]) {
            i++;

          }
          else{
            print(userCheckSnapshot.docs[j]["chatRoomId"]);
          }
        }
        print(userCheckSnapshot.docs.length);
        print(i);

        if (i == 0) {
          var result = await FirebaseDatabase().createChatRoom(chatRoom, id);
          userCheckSnapshot = await FirebaseDatabase().getUserChatCheck(Constants.email);

          print(i);
        } else {}

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => DetailedMessage(
                      name: userName,
                      email: email,
                      imageUrl: imageUrl,
                      id: id,
                    )));
        await FirebaseDatabase().uploadHistory(
            data: map, userId: Constants.email, id: id, userName: userName);
      } else {
        print("You cannot send");
      }
    }

    Widget searchListHistory() {
      return historySnapshot == null
          ? Container()
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: historySnapshot,
              builder: (context, snapshot) {
                return snapshot.hasData && (snapshot.data?.docs.length)! >= 1
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.history),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("Recent Searches"),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text("Delete search History"),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                   showmessage("Deleting....");
                                                  await FirebaseDatabase()
                                                      .deleteHistory(
                                                          Constants.email);


                                                  Navigator.pop(context);
                                                  showmessage(
                                                    "Deleted",
                                                  );
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "NO",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Clear History",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            itemBuilder: (context, position) {
                              var search = snapshot.data?.docs[position];

                              return search!["email"] != Constants.email
                                  ? GestureDetector(
                                      onTap: () async {
                                        await createChatRoom(
                                            getChatRoomId(
                                                search["name"], Constants.name),
                                            getChatRoomId(search["email"],
                                                Constants.email),
                                            getImageId(search["imageUrl"],
                                                Constants.imageUrl),
                                            search["email"]);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            children: [
                                              search["imageUrl"]==""?
                                            CircleAvatar(
                                            radius:28,
                                            child: Text(search["name"][0],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20
                                              ),
                                            ),
                                            backgroundColor:Kcolors[Random().nextInt(4)] ,
                                            ):

                                            CircleAvatar(
                                                radius: 28,
                                                backgroundImage: NetworkImage(
                                                    search["imageUrl"]),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  search["name"],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          )),
                                    )
                                  : SizedBox();
                            },
                            itemCount: snapshot.data?.docs.length,
                          ),
                        ],
                      )
                    : Container();
              });
      // :Container();
    }

    return history != null
        ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: history,
            builder: (context, snapshot) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>>? newgfgList =
                  snapshot.data?.docs.toList();

              final myList = query.isEmpty
                  ? newgfgList
                  : newgfgList
                      ?.where((element) => element["name"]
                          .toString()
                          .toLowerCase()
                          .contains(query))
                      .toList();
              return snapshot.hasData
                  ? Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        children: [
                          Column(
                            children: [searchListHistory()],
                          ),
                          Divider(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemBuilder: (context, position) {
                                        final search =
                                            snapshot.data?.docs[position];
                                        return myList![position]["email"] !=
                                                Constants.email
                                            ? myList.isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      await createChatRoom(
                                                          getChatRoomId(
                                                              myList[position]
                                                                  ["name"],
                                                              Constants.name),
                                                          getChatRoomId(
                                                              myList[position]
                                                                  ["email"],
                                                              Constants.email),
                                                          getImageId(
                                                              myList[position]
                                                                  ["imageUrl"],
                                                              Constants
                                                                  .imageUrl),
                                                          myList[position]
                                                              ["email"]);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 8),
                                                      child: ListTile(
                                                        leading:  myList[position]["imageUrl"]==""?
                                                        CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: Kcolors[Random().nextInt(4)],
                                                          child: Text(
                                                            myList[position]["name"][0],
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 22
                                                            ),
                                                          ),

                                                        ): CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                          NetworkImage(myList[
                                                          position]
                                                          ["imageUrl"]),
                                                        ),
                                                        title: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Text(
                                                            myList[position]
                                                                ["name"],
                                                            style: TextStyle(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                            : Container();
                                      },
                                      itemCount: myList!.length),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container();
            })
        : Container();
  }
}
