import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:untitled6/model/constants.dart';

class FirebaseDatabase {
  deleteHistory(userId) async {
    var value = await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection('searchHistory');
    var snapshots = await value.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

  }

  getUserByEmail(String email) async {
    var value = await FirebaseFirestore.instance
        .collection("User")
        .where("email", isEqualTo: email)
        .get();
    return value;

  }

  getUserByEmailSnapshots(String email)async{

    var value = await FirebaseFirestore.instance
        .collection("User")
        .where("email", isEqualTo: email)
        .snapshots();
    return value;
  }

  getHistory({required userId}) async {

    var value = await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection('searchHistory')
        .snapshots();

    return value;
  }

  getUser() async {
    var value = await FirebaseFirestore.instance.collection("User").snapshots();
    return value;
  }
  updateProfilePicture(email,data)async{
    var value = await FirebaseFirestore.instance.collection("User").doc(email).update(data);
  }

  getUserByName(String userName) async {
    var value = await FirebaseFirestore.instance
        .collection("User")
        .where("name", isEqualTo: userName)
        .snapshots();

    return value;
  }

  uploadHistory(
      {required data, required userId, required id, required userName}) async {
    var value = await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection('searchHistory')
        .doc(id)
        .set(data);


  }

  uploadName(data, id) {
    FirebaseFirestore.instance.collection("User").doc(id).set(data);
  }

  uploadChatHistory(
      {required data, required userId, required id,}) async {
    var value = await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection('chats')
        .doc(id)
        .set(data);

    return value;
  }

  createChatRoom(data, id) async {
    var value = await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(id)
        .set(data);
    return value;
  }

  addMessages(chatRoomId, messageMap) async {

   var  value = await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap);
   return value;
  }
  addLastMessage(chatRoomId, map) async {

    var  value = await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId).update(map);
    return value;
  }
  seeMessage(chatRoomId)async{
    var value = await  FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats").orderBy("time").snapshots();
    return value;
  }
  seeMessages(chatRoomId)async{
    var value = await  FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats").orderBy("time").get();
    return value;
  }
  getUserChats(name)async{
    var value = await FirebaseFirestore.instance.collection("ChatRoom").orderBy("lastMessageTime",descending: true).where("users",arrayContains: name).snapshots();
    return value;
  }
  getUserChatCheck(name)async{
    var value = await FirebaseFirestore.instance.collection("ChatRoom").get();
    return value;
  }
  deleteConversation(id,data)async{

    var value = await FirebaseFirestore.instance.collection("ChatRoom").doc(id).collection("chats").get();

    for(var doc in value.docs){
      doc.reference.delete();
    }
  }
  deleteChat(id,ids)async{
    await FirebaseFirestore.instance.collection("ChatRoom").doc(id).collection("chats").doc(ids).update({
      "hideFor":FieldValue.arrayUnion([Constants.email])
    });
  }
  removeChat(id,ids)async{
    await FirebaseFirestore.instance.collection("ChatRoom").doc(id).collection("chats").doc(ids).update({
      "message": "Unsent the message",
      "type":"text"
    });
  }
  updateImage(id,image) async {
    try {

      var query = await FirebaseFirestore.instance.collection("ChatRoom").doc(id).collection("chats")
          .where("message", isEqualTo: "").where("type",isEqualTo: "image")
          .get();

      for(var item in query.docs) {

        FirebaseFirestore.instance.collection("ChatRoom").doc(id).collection("chats")
            .doc(item.id)
            .update({
          "message": image
        });
      }
    }
    catch (e) {
      print(e);
    }
  }
  // updatePicture(id,ids,image)async{
  //   await FirebaseFirestore.instance.collection("ChatRoom").doc(id).collection("chats").where("message",isEqualTo:"" ).where("type",isEqualTo: "image").update({
  //     "message": image
  //   });
  // }
  addReaction(id,ids,text)async{
    await FirebaseFirestore.instance.collection("ChatRoom").doc(id).collection("chats").doc(ids).update({
      "reaction": text
    });
  }
}
