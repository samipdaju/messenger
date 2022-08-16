import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled6/screens/messageScreen/messgeScreen.dart';
import 'package:untitled6/firebase/auth.dart';
import 'package:untitled6/firebase/database.dart';
import 'package:untitled6/screens/loggingin/splash.dart';
import '../../model/sharedPreferences.dart';
import 'signUp.dart';
import '../../widgets/textfield.dart';
import '../../widgets/button.dart';

import '../../constants.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late QuerySnapshot querySnapshot;


String message="";
  signIn() async {

    if (formKey.currentState!.validate()) {
      showmessage("Signing in...");

      querySnapshot =
      await FirebaseDatabase().getUserByEmail(emailController.text);
      SavingFunction().saveEmailPreference(emailController.text);
      try {
        var result = await AuthServices()
            .signIn(emailController.text, passwordController.text);

        SavingFunction().savePicturePreference(querySnapshot.docs[0]["imageUrl"]);

        SavingFunction().saveUserNamePreference(querySnapshot.docs[0]["name"]);


        if (result != null) {
          SavingFunction().saveUserLoggedInPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SplashScreen()));
        }
      }catch(e){
        print(e);
  showmessage(formatMessage(e.toString()));

      }
    }
  }
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              Image.asset(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? "assets/doveDark.png"
                    : "assets/doveLight.png",
                height: 146,
              ),
              SizedBox(
                height: 40,
              ),
              Form(
                key: formKey,

                child: Column(

                  children: [
                    NewTextArea(
                        controller: emailController,
                        label: "Enter your email address",
                        iconData: Icon(
                          Icons.email,
                        ),
                        onChanged: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)
                              ? null
                              : "Please enter a valid email address";
                        }),
                    NewTextArea(
                        show: show,
                        suffixData: InkWell(
                            child: !show
                                ? Icon(Icons.visibility,
                            color: KprimaryColor,)
                                : Icon(Icons.visibility_off,
                              color: KprimaryColor,),
                            onTap: () {
                              setState(() {
                                show = !show;
                              });
                            }),
                        controller: passwordController,
                        label: "Enter your Password",
                        iconData: Icon(Icons.vpn_key_rounded),
                        onChanged: (value) {
                          return value!.length < 6
                              ? "Please enter password with more than 6 charracters"
                              : null;
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
                child: Column(
                  children: [
                    PrimaryButton(
                      text: "Sign In",
                      onPress: () {
                        signIn();
                      },
                      color: KprimaryColor,
                      padding: EdgeInsets.all(20),
                    ),
                    PrimaryButton(
                      text: "Sign In With Google",
                      onPress: () {
                        signIn();
                      },
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                      padding: EdgeInsets.all(20),
                    ),
                    
                    Text(message)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      "No account created yet?",
                      style: TextStyle(color: KprimaryColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: KsecondaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: KprimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
