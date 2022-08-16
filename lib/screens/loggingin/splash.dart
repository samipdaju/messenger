import 'package:flutter/material.dart';
import 'package:untitled6/model/sharedPreferences.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    checkUserState();

    // TODO: implement initState
    super.initState();
  }



  void checkUserState()async{

  bool? userLogin =await SavingFunction().getUserLoggedInPreference();



    if(userLogin!=null) {
      if (userLogin) {
        Navigator.pushReplacementNamed(context, "0");
      }
      else {
        Navigator.pushReplacementNamed(context, "logIn");
      }
    }
    else  {
      Navigator.pushReplacementNamed(context, "home");

    }







  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [

            Image.asset("assets/doveLight.png",
            height: 250,),
            Positioned(
              right: 75,
              bottom:0,
              child: CircularProgressIndicator(
                value: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}