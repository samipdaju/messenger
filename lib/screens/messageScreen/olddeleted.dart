// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/scheduler.dart';
// // import 'package:http/http.dart';
// //
// // import '../../constants.dart';
// // import '../detailedMessage/detailedmessage.dart';
// // import '../../model/constants.dart';
// // import '../../firebase/database.dart';
// // import '../../model/sharedPreferences.dart';
// //
// // class SearchPage extends StatefulWidget {
// //   @override
// //   _SearchPageState createState() => _SearchPageState();
// // }
// //
// // class _SearchPageState extends State<SearchPage> {
// //   TextEditingController searchController = TextEditingController();
// //
// //   var querySnapshot;
// //   var historySnapshot;
// //   var userSnapshot;
// //
// //   late var result;
// //   late var history;
// //   int? length = 0;
// //   var i = 0;
// //
// //   FirebaseDatabase database = FirebaseDatabase();
// //
// //   createChatRoom(userName, email, imageUrl, idName) async {
// //     if (userName != Constants.name) {
// //       Map<String, dynamic> map = {
// //         "name": getName(a: userName, constant: Constants.name),
// //         "email": getName(a: email, constant: Constants.email),
// //         "imageUrl": getImage(a: imageUrl, constant: Constants.imageUrl),
// //       };
// //
// //       List<String> users = [
// //         getName(a: userName, constant: Constants.name),
// //         Constants.name
// //       ];
// //       var id = getChatRoomId(idName, Constants.name);
// //
// //       Map<String, dynamic> chatRoom = {
// //         "users": users,
// //         "chatRoomId": id,
// //         "name": userName,
// //         "email": email,
// //         "imageUrl": imageUrl,
// //         "lastMessage": "",
// //         "lastMessageTime": ""
// //       };
// //       for (int j = 0; j < userSnapshot.docs.length; j++) {
// //         if (id == userSnapshot.docs[j]["chatRoomId"]) {
// //           i++;
// //           setState(() {});
// //         }
// //       }
// //       if (i == 0) {
// //         var result = await FirebaseDatabase().createChatRoom(chatRoom, id);
// //       } else {}
// //
// //       Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(
// //               builder: (BuildContext context) => DetailedMessage(
// //                     name: userName,
// //                     email: email,
// //                     imageUrl: imageUrl,
// //                     id: id,
// //                   )));
// //       await FirebaseDatabase().uploadHistory(
// //           data: map, userId: Constants.email, id: id, userName: userName);
// //
// //       print(result.toString());
// //     } else {
// //       print("You cannot send");
// //     }
// //   }
// //
// //   getValue() async {
// //     setState(() {
// //       result = FirebaseDatabase().getUserByName(searchController.text);
// //     });
// //     querySnapshot = await result;
// //   }
// //
// //   getUserInfo() async {
// //     Constants.name = await SavingFunction().getUserNamePreference();
// //     Constants.email = await SavingFunction().getEmailPreference();
// //
// //     historySnapshot =
// //         await FirebaseDatabase().getHistory(userId: Constants.email);
// //     querySnapshot = await FirebaseDatabase().getUser();
// //     userSnapshot = await FirebaseDatabase().getUserChatCheck(Constants.name);
// //     setState(() {});
// //   }
// //
// //   Widget searchListHistory() {
// //     return historySnapshot == null
// //         ? Container()
// //         : StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
// //           stream: historySnapshot,
// //           builder: (context, snapshot) {
// //
// //             return snapshot.hasData? GridView.builder(
// //                 shrinkWrap: true,
// //                 physics: ScrollPhysics(),
// //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                   crossAxisCount: 4,
// //                 ),
// //                 itemBuilder: (context, position) {
// //                   var search = snapshot.data?.docs[position];
// //
// //                   return search!["email"] != Constants.email
// //                       ? GestureDetector(
// //                           onTap: () async {
// //                             await createChatRoom(
// //                                 getChatRoomId(
// //                                     search["name"], Constants.name),
// //                                 getChatRoomId(
// //                                     search["email"], Constants.email),
// //                                 getImageId(search["imageUrl"],
// //                                     Constants.imageUrl),
// //                                 search["name"]);
// //
// //
// //                           },
// //                           child: Container(
// //                               padding: EdgeInsets.symmetric(horizontal: 10),
// //                               child: Column(
// //                                 children: [
// //                                   CircleAvatar(
// //                                     radius: 28,
// //                                     backgroundImage: NetworkImage(
// //                                        search["imageUrl"]),
// //                                   ),
// //                                   SizedBox(
// //                                     height: 15,
// //                                   ),
// //                                   Flexible(
// //                                     child: Text(
// //                                       search["name"],
// //                                       style: TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 12),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               )),
// //                         )
// //                       : SizedBox();
// //                 },
// //                 itemCount: snapshot.data?.docs.length,
// //               ):Container();
// //           }
// //         );
// //     // :Container();
// //   }
// //
// //   Widget searchList() {
// //     return querySnapshot == null
// //         ? Container()
// //         : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
// //             stream: querySnapshot,
// //             builder: (context, snapshot) {
// //               return snapshot.hasData
// //                   ? ListView.builder(
// //                       shrinkWrap: true,
// //                       physics: ScrollPhysics(),
// //                       itemBuilder: (context, position) {
// //                         var search = snapshot.data?.docs[position];
// //                         return search!["name"] != Constants.name
// //                             ? Column(
// //                                 children: [
// //                                   InkWell(
// //                                     onTap: () async {
// //                                       await createChatRoom(
// //                                           getChatRoomId(
// //                                               search["name"], Constants.name),
// //                                           getChatRoomId(
// //                                               search["email"], Constants.email),
// //                                           getImageId(search["imageUrl"],
// //                                               Constants.imageUrl),
// //                                           search["name"]);
// //
// //
// //                                     },
// //                                     child: Container(
// //                                         padding: EdgeInsets.all(15),
// //                                         child: Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.spaceBetween,
// //                                           children: [
// //                                             Expanded(
// //                                               child: Row(
// //                                                 children: [
// //                                                   CircleAvatar(
// //                                                     radius: 25,
// //                                                     backgroundImage:
// //                                                         NetworkImage(
// //                                                       getImage(
// //                                                           a: search["imageUrl"],
// //                                                           constant: Constants
// //                                                               .imageUrl),
// //                                                     ),
// //                                                   ),
// //                                                   SizedBox(
// //                                                     width: 15,
// //                                                   ),
// //                                                   Flexible(
// //                                                     child: Column(
// //                                                       mainAxisAlignment:
// //                                                           MainAxisAlignment
// //                                                               .start,
// //                                                       crossAxisAlignment:
// //                                                           CrossAxisAlignment
// //                                                               .start,
// //                                                       children: [
// //                                                         Text(
// //                                                           getName(
// //                                                               a: search["name"],
// //                                                               constant:
// //                                                                   Constants
// //                                                                       .name),
// //                                                           style: TextStyle(
// //                                                               fontSize: 18),
// //                                                         ),
// //                                                       ],
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         )),
// //                                   ),
// //                                 ],
// //                               )
// //                             : SizedBox();
// //                       },
// //                       itemCount: snapshot.data?.docs.length,
// //                     )
// //                   : Container();
// //             });
// //     // :Container();
// //   }
// //
// //   @override
// //   void initState() {
// //     getUserInfo();
// //     // TODO: implement initState
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child:
// //         Column(
// //           children: [
// //             Padding(
// //               padding:
// //                   const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
// //               child: Row(
// //                 children: [
// //                   BackButton(),
// //                   Expanded(
// //                     child: TextField(
// //                       controller: searchController,
// //                       autofocus: true,
// //                       decoration: InputDecoration(
// //                         border: InputBorder.none,
// //                         hintText: "Search",
// //                       ),
// //                       style: TextStyle(fontSize: 18),
// //                     ),
// //                   ),
// //                   IconButton(
// //                       onPressed: () async {
// //                         var val =
// //                             await database.getUserByName(searchController.text);
// //                         print("value is $val");
// //                         setState(() {
// //                           querySnapshot = val;
// //                         });
// //                         print(querySnapshot.docs.length);
// //                       },
// //                       icon: Icon(Icons.search))
// //                 ],
// //               ),
// //             ),
// //             historySnapshot != null
// //                 ? historySnapshot.data?.docs.length >= 1
// //                     ? Column(
// //                         children: [
// //                           Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 Row(
// //                                   children: [
// //                                     Icon(Icons.history),
// //                                     SizedBox(
// //                                       width: 20,
// //                                     ),
// //                                     Text("Recent Searches"),
// //                                   ],
// //                                 ),
// //                                 GestureDetector(
// //                                   onTap: () {
// //                                     showDialog(
// //                                         context: context,
// //                                         builder: (BuildContext context) {
// //                                           return AlertDialog(
// //                                             title:
// //                                             Text("Delete search History"),
// //                                             actions: [
// //                                               TextButton(
// //                                                 onPressed: () async {
// //                                                   await FirebaseDatabase()
// //                                                       .deleteHistory(
// //                                                       Constants.email);
// //                                                   showmessage("Deleting....");
// //                                                   historySnapshot =
// //                                                   await FirebaseDatabase()
// //                                                       .getHistory(
// //                                                       userId: Constants
// //                                                           .email);
// //
// //                                                   setState(() {});
// //
// //                                                   Navigator.pop(context);
// //                                                   showmessage(
// //                                                     "Deleted",
// //                                                   );
// //                                                 },
// //                                                 child: Text(
// //                                                   "Yes",
// //                                                   style:
// //                                                   TextStyle(fontSize: 18),
// //                                                 ),
// //                                               ),
// //                                               TextButton(
// //                                                 onPressed: () {
// //                                                   Navigator.pop(context);
// //                                                 },
// //                                                 child: Text(
// //                                                   "NO",
// //                                                   style:
// //                                                   TextStyle(fontSize: 18),
// //                                                 ),
// //                                               )
// //                                             ],
// //                                           );
// //                                         });
// //                                   },
// //                                   child: Text(
// //                                     "Clear History",
// //                                     style: TextStyle(
// //                                         decoration: TextDecoration.underline,
// //                                         color: Colors.blue),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           searchListHistory()
// //                         ],
// //                       )
// //                     : SizedBox()
// //                 : SizedBox(),
// //             Divider(),
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 child: searchList(),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import '../loggingin/signIn.dart';
// import '../messageScreen/messgeScreen.dart';
// import '../../firebase/auth.dart';
// import '../../model/constants.dart';
// import '../../firebase/database.dart';
//
// import '../../model/sharedPreferences.dart';
//
// import '../../widgets/textfield.dart';
// import '../../widgets/button.dart';
//
// import '../../constants.dart';
//
// class ProfilePage extends StatefulWidget {
//   ProfilePage({})
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   bool show = true;
//   String donwloadUrl = "";
//   final formKey = GlobalKey<FormState>();
//
//   AuthServices authServices = AuthServices();
//   FirebaseDatabase firebaseDatabase = FirebaseDatabase();
//
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   signUp() async {
//
//     if (formKey.currentState!.validate()) {
//       if (fileImage != null) {
//         setState(() {
//           showmessage("Processing Profile Image...");
//         });
//         await uploadImage();
//
//         print("link is this $donwloadUrl");
//
//       }
//       showmessage("Signing Up...");
//       try {
//         var result = await authServices.signUp(
//             emailController.text, passwordController.text);
//         if (result != null) {
//           Map<String, dynamic> map = {
//             "history": [],
//             "name": userNameController.text,
//             "email": emailController.text,
//             "imageUrl": donwloadUrl =="" ? image : donwloadUrl
//           };
//           print("Url is this : $donwloadUrl");
//
//           var id = emailController.text.toString();
//
//           await firebaseDatabase.uploadName(map, id);
//           SavingFunction().saveUserNamePreference(userNameController.text);
//           SavingFunction().saveEmailPreference(emailController.text);
//           SavingFunction().savePicturePreference(fileImage!=null?donwloadUrl:image);
//           SavingFunction().saveUserLoggedInPreference(true);
//
//           Constants.name = await SavingFunction().getUserNamePreference();
//           Constants.email = await SavingFunction().getEmailPreference();
//
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => MessageScreen()));
//         }
//       } catch (e) {
//         print(e);
//         showmessage(formatMessage(e.toString()));
//       }
//     }
//   }
//
//   File? fileImage;
//
//   getImage() async {
//     var images =
//     await ImagePicker.platform.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       fileImage = File(images!.path);
//       print(fileImage!.path.toString());
//       print("hi");
//     });
//   }
//
//   uploadImage() async {
//     final ref = await FirebaseStorage.instance
//         .ref("profilepics/${fileImage!.path.toString()}");
//
//     var result = ref.putFile(fileImage!);
//
//     setState(() {});
//
//     if (result == null) return;
//
//
//     final snapshot = await result;
//
//     donwloadUrl = await snapshot.ref.getDownloadURL();
//
//     setState(() {
//
//     });
//     print('Download-Link: $donwloadUrl');
//
//
//     return donwloadUrl;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sign Up"),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Center(
//               child: InkWell(
//                 onTap: () {
//                   getImage();
//                 },
//                 child: Stack(
//                   children: [
//                     ClipOval(
//                       child: new SizedBox(
//                           width: 180,
//                           height: 180,
//                           child: (fileImage != null)
//                               ? Image.file(
//                             fileImage!,
//                             fit: BoxFit.cover,
//                           )
//                               : CircleAvatar(child: Icon(Icons.person,size: 80,))
//                       ),
//                     ),
//                     Positioned(
//                         right: 5,
//                         bottom: 00,
//                         child: CircleAvatar(
//                           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                           radius: 24,
//                           child: Icon(
//                             Icons.camera_alt,
//                             color: KprimaryColor,
//                             size: 32,
//                           ),
//                         ))
//                   ],
//                 ),
//               ),
//             ),
//             Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   NewTextArea(
//                       controller: userNameController,
//                       label: "Enter your name",
//                       iconData: Icon(Icons.person),
//                       onChanged: (value) {
//                         return value!.length < 4
//                             ? "Please use more than 4 characters "
//                             : null;
//                       }),
//                   NewTextArea(
//                       controller: emailController,
//                       label: "Enter your email address",
//                       iconData: Icon(Icons.email),
//                       onChanged: (value) {
//                         return RegExp(
//                             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                             .hasMatch(value!)
//                             ? null
//                             : "Please enter a valid email address";
//                       }),
//                   NewTextArea(
//                       show: show,
//                       suffixData: InkWell(
//                           child: !show
//                               ? Icon(
//                             Icons.visibility,
//                             color: KprimaryColor,
//                           )
//                               : Icon(
//                             Icons.visibility_off,
//                             color: KprimaryColor,
//                           ),
//                           onTap: () {
//                             setState(() {
//                               show = !show;
//                             });
//                           }),
//                       controller: passwordController,
//                       label: "Enter your Password",
//                       iconData: Icon(Icons.vpn_key_rounded),
//                       onChanged: (value) {
//                         return value!.length < 6
//                             ? "Please enter password with more than 6 charracters"
//                             : null;
//                       }),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: PrimaryButton(
//                 text: "Sign Up",
//                 onPress: () async {
//                   await signUp();
//                 },
//                 color: KsecondaryColor,
//                 padding: EdgeInsets.all(20),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Row(
//                 children: [
//                   Text(
//                     "Already have an account?",
//                     style: TextStyle(color: KprimaryColor),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pushReplacement(context,
//                           MaterialPageRoute(builder: (context) => SignIn()));
//                     },
//                     child: Text(
//                       "Sign In",
//                       style: TextStyle(
//                           decoration: TextDecoration.underline,
//                           color: KsecondaryColor),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
