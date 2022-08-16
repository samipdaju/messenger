import 'package:flutter/material.dart';
import 'package:untitled6/profile/profile.dart';
import 'package:untitled6/screens/messageScreen/messgeScreen.dart';
import 'package:untitled6/model/sharedPreferences.dart';
import 'package:untitled6/screens/loggingin/signIn.dart';
import 'package:untitled6/screens/loggingin/signUp.dart';
import 'package:untitled6/screens/loggingin/splash.dart';

import 'theme.dart';
import 'screens/loggingin/homescreen.dart';

import 'package:provider/provider.dart';

import 'model/statemanagement/messagemodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MessageModel>(create: (_) => MessageModel()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: lightThemeData(context),
          darkTheme: darkThemeData(context),
          initialRoute: "splash",
          routes: {
            "splash": (context) => SplashScreen(),
            "logIn": (context) => SignIn(),

            "register": (context) => SignUp(),
            "home": (context) => HomeScreen(),
            "0": (context) => MessageScreen(),
          },
        ));
  }
}
