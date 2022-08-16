import 'package:flutter/material.dart';
import 'login.dart';

import '../../model/apimodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool load = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: load?CircularProgressIndicator():SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          Spacer(
            flex: 2,
          ),
          Image.asset("assets/peeps.png"),
          Spacer(
            flex: 3,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                " "
                "Welcome to our messaging app. \n "
                "      Freedom for everyone",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Spacer(
            flex: 2,
          ),
          FittedBox(
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => LogIn()));
              },
              child: Row(
                children: [
                  Text(
                    "Skip",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).textTheme.bodyText2!.color),
                  ),
                  Icon(Icons.arrow_right_alt),
                ],
              ),
            ),
          ),
        ])));
  }
}
