import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/screens/detailedMessage/detailedmessage.dart';
import 'package:untitled6/screens/messageScreen/olddeleted.dart';
import 'package:untitled6/screens/loggingin/splash.dart';
import '../../constants.dart';
import '../../model/apimodel.dart';
import '../../model/constants.dart';
import '../../firebase/database.dart';
import '../../model/message.dart';
import '../../model/sharedPreferences.dart';
import '../../profile/profile.dart';
import 'search.dart';
import '../loggingin/signIn.dart';
import '../../widgets/textfield.dart';

import 'body.dart';
import '../../firebase/auth.dart';
import '../../model/chatmodel.dart';

class MessageScreen extends StatefulWidget {
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var userSnapshot;
  var userChatSnapshot;
  var historySnapshot;
  var userCheckSnapshot;
  var currentUserSnapshot;



  FirebaseDatabase database = FirebaseDatabase();

  getUser() async {




    Constants.name = await SavingFunction().getUserNamePreference();
    Constants.email = await SavingFunction().getEmailPreference();
    currentUserSnapshot = await FirebaseDatabase().getUserByEmailSnapshots(Constants.email);
    Constants.imageUrl = await SavingFunction().getPicture();
    userSnapshot = await FirebaseDatabase().getUserChats(Constants.email);

    historySnapshot =
        await FirebaseDatabase().getHistory(userId: Constants.email);
    userChatSnapshot = await FirebaseDatabase().getUser();
    userCheckSnapshot =
        await FirebaseDatabase().getUserChatCheck(Constants.email);
    setState(() {});
  }

  int selectedIndex = 0;
  late List chats;
  bool load = true;
  bool search = true;

  @override
  void initState() {
    initialize();
    getUser();
    // TODO: implement initState
    super.initState();
  }

  initialize() async {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: buildAppBar(onPressed: () async {
        showSearch(
            context: context,
            delegate: SearchPages(userChatSnapshot, (int) {}, historySnapshot,
                userCheckSnapshot));
      }),
      body: Body(userSnapshot,userChatSnapshot,selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {


            if(selectedIndex != value){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfilePage(

              )));
            }

          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: "Calls",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "People",
          ),
          BottomNavigationBarItem(
            icon: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
              stream: currentUserSnapshot,
              builder: (context, snapshot) {
                return
                  snapshot.hasData?
                  snapshot.data?.docs[0]["imageUrl"]== ""?
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: KsecondaryColor,
                    child: Text(Constants.name[0],
                    style: TextStyle(
                      color: Colors.white,

                    ),),
                  ):CircleAvatar(
                   backgroundImage: NetworkImage(snapshot.data?.docs[0]["imageUrl"]),
                  radius: 14,)
                      :CircleAvatar(
                  backgroundImage: NetworkImage(Constants.imageUrl),
                  radius: 14,
                );
              }
            ),
            label: Constants.name,
          ),
        ],
      ),
    );
  }


  List titles = [
   "Messages",
    "Calls",
    "ASfsafijol",
    "Profile"
  ];
  AppBar buildAppBar({required VoidCallback onPressed}) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text( titles[selectedIndex]),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.search) )
      ],
    );
  }
}
