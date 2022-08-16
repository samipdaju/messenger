import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../messageScreen/messgeScreen.dart';
import '../../firebase/auth.dart';
import '../../model/constants.dart';
import '../../firebase/database.dart';

import '../../model/sharedPreferences.dart';
import 'signIn.dart';
import '../../widgets/textfield.dart';
import '../../widgets/button.dart';

import '../../constants.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool show = true;
  String donwloadUrl = "";
  final formKey = GlobalKey<FormState>();
  var querySnapshot;

  AuthServices authServices = AuthServices();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase();

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUp() async {

    if (formKey.currentState!.validate()) {
      if (fileImage != null) {

        setState(() {
          showmessage("Processing Profile Image...");
        });
        await uploadImage();

        print("link is this $donwloadUrl");

      }
      showmessage("Signing Up...");
      try {
        var result = await authServices.signUp(
            emailController.text, passwordController.text);
        if (result != null) {
          Map<String, dynamic> map = {
            "history": [],
            "name": userNameController.text,
            "email": emailController.text,
            "imageUrl": donwloadUrl =="" ? image : donwloadUrl
          };
          print("Url is this : $donwloadUrl");

          var id = emailController.text.toString();


          await firebaseDatabase.uploadName(map, id);
          querySnapshot =
          await FirebaseDatabase().getUserByEmail(emailController.text);
          SavingFunction().saveUserNamePreference(querySnapshot.docs[0]["name"]);
          SavingFunction().saveEmailPreference(querySnapshot.docs[0]["email"]);
          SavingFunction().savePicturePreference(fileImage!=null?querySnapshot.docs[0]["iamgeUrl"]:image);
          SavingFunction().saveUserLoggedInPreference(true);

          Constants.name = await SavingFunction().getUserNamePreference();
          Constants.email = await SavingFunction().getEmailPreference();

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MessageScreen()));
        }
      } catch (e) {
        print(e);
        showmessage(formatMessage(e.toString()));
      }
    }
  }

  File? fileImage;

  getImage() async {
    var images =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      fileImage = File(images!.path);
      print(fileImage!.path.toString());
      print("hi");
    });
  }

  uploadImage() async {
    final ref = await FirebaseStorage.instance
        .ref("profilepics/${fileImage!.path.toString()}");

    var result = ref.putFile(fileImage!);

    setState(() {});

    if (result == null) return;


      final snapshot = await result;

    donwloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {

      });
      print('Download-Link: $donwloadUrl');


    return donwloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  getImage();
                },
                child: Stack(
                  children: [
                    ClipOval(
                      child: new SizedBox(
                        width: 180,
                        height: 180,
                        child: (fileImage != null)
                            ? Image.file(
                                fileImage!,
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(child: Icon(Icons.person,size: 80,))
                      ),
                    ),
                    Positioned(
                        right: 5,
                        bottom: 00,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          radius: 24,
                          child: Icon(
                            Icons.camera_alt,
                            color: KprimaryColor,
                            size: 32,
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  NewTextArea(
                      controller: userNameController,
                      label: "Enter your name",
                      iconData: Icon(Icons.person),
                      onChanged: (value) {
                        return value!.length < 4
                            ? "Please use more than 4 characters "
                            : null;
                      }),
                  NewTextArea(
                      controller: emailController,
                      label: "Enter your email address",
                      iconData: Icon(Icons.email),
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
                              ? Icon(
                                  Icons.visibility,
                                  color: KprimaryColor,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: KprimaryColor,
                                ),
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
              padding: const EdgeInsets.all(15.0),
              child: PrimaryButton(
                text: "Sign Up",
                onPress: () async {
                  await signUp();
                },
                color: KsecondaryColor,
                padding: EdgeInsets.all(20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: KprimaryColor),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: KsecondaryColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
