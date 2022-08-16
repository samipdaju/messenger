import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'message.dart';

import 'chatmodel.dart';

class Logic {
  List<Chats> chatss = [];
  // String baseUrl =
  //     "https://b98b-2400-1a00-b030-d7f3-4057-eab3-c98a-72f4.ngrok.io/";

  String baseUrl ="http://42f0-2400-1a00-b030-259d-a471-1615-1433-d8b3.ngrok.io/";

  getApi() async {
    var url = Uri.parse(baseUrl);
    Response response;
    response = await get(url);
    var result = jsonDecode(response.body);

    print(result);
    List messages = [];

    //
    // for (int i = 0; i < result.length; i++) {
    // for(int j=0;j<result[i]["Chat Messages"].length;j++){
    //
    //
    //     messages.add(
    //         ChatMessage(
    //         text: result[i]["Chat Messages"][j]["message"],
    //         status: result[i]["Chat Messages"][j]["status"],
    //         isSender: result[i]["Chat Messages"][j]["isSender"],
    //         messageType: result[i]["Chat Messages"][j]["type"]));
    //   }
    // }

    for (int i = 0; i < result.length; i++) {

      chatss.add(Chats(
          name: result[i]["name"],
          imageUrl: result[i]["imageUrl"],
          isActive: result[i]["isActive"],
          time: result[i]["time"],
          messages:result[i]["Chat Messages"]

      )

      );

    }


    return chatss;
  }
  postApi(data,String name)async{
    await post(
        Uri.parse("$baseUrl/user/?user=$name"),body: data
    );
  }
}
