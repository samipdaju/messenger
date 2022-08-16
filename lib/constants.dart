import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model/constants.dart';

const KprimaryColor = Colors.green;
const KsecondaryColor = Colors.orange;
const KcontentLightTheme = Color(0xff0E1E2B);
const KContentDarkTheme = Colors.white;
const KWarningColor = Colors.amber;
const kErrorColor = Colors.red;
const image ="";
    // "https://media.istockphoto.com/vectors/person-icon-flat-black-round-button-vector-illustration-vector-id1139505484?k=20&m=1139505484&s=170667a&w=0&h=uVTD_s2EnF35J7s0-4M-G3lcHbIVfmCAlu_y-jinq2c=";
const Kcolors =[
  KsecondaryColor,
  Colors.deepPurpleAccent,
  Colors.blue,
  Colors.green,
];
showmessage(message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.SNACKBAR,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

formatMessage(message) {
  switch (message) {
    case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
      return "No User with Following E-mail";

    case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
      return "Email adress already occupied. Try new one";

    case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
      return "Password doesnot match \n Try recovering password by Forgot Password option";

    case "[firebase_auth/unknown] com.google.firebase.FirebaseException: An internal error has occurred. [ Read error:ssl=0xbdf048e8: I/O error during system call, Connection reset by peer ]":
      return "Connection Error.Please check your internet connection.";
    default:
      return "Error Occured";
  }
}

getChatRoomId(String a, String b) {
  if(a.compareTo(b)==0){
    return a;
  }
  if (a.compareTo(b) == -1) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

getImageId(String a, String b) {
  if(a.compareTo(b)==0){
return a;
  }
  if (a.compareTo(b) == -1) {
    return "$b{}$a";
  }

  else {
    return "$a{}$b";
  }
}

getName({a, constant}) {
  if(a== constant){
    return a;
  }

  return a.toString().replaceAll("_", "").replaceAll(constant, "");
}
getImage({a, constant}) {
  if(a== constant){
    return a;
  }
  return a.toString().replaceAll("{}", "").replaceAll(constant, "");
}
