import 'package:flutter/material.dart';
import 'package:untitled6/screens/loggingin/signUp.dart';
import '../../constants.dart';
import 'signIn.dart';
import '../../widgets/button.dart';

import '../messageScreen/messgeScreen.dart';


class LogIn extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
Spacer(flex: 2,),
             Image.asset( MediaQuery.of(context).platformBrightness ==Brightness.light?"assets/doveDark.png":
               "assets/doveLight.png",
               height:146,
             ),
              Spacer(),
              SizedBox(height: 40,),

              PrimaryButton(text: "Sign In", onPress: (){

                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => SignIn()));


              }, color: KprimaryColor,
                padding: EdgeInsets.all(20),
              ),
              SizedBox(height: 40,),
              PrimaryButton(text: "Sign Up", onPress: (){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignUp()));


              }, color: KsecondaryColor,
                padding: EdgeInsets.all(20),
              ),
              Spacer(flex: 2,),



            ],
          ),
        ),
      ),
    );
  }
}
