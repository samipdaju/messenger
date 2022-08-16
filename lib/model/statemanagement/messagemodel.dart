import 'package:flutter/cupertino.dart';


import '../chatmodel.dart';

class MessageModel extends ChangeNotifier{


  addMessage( message,Chats chats){

    chats.messages.add(message);
    notifyListeners();
  }


}
