

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:untitled6/screens/loggingin/splash.dart';

import '../../firebase/auth.dart';
import '../../model/constants.dart';
import '../../firebase/database.dart';

import '../../model/sharedPreferences.dart';
import '../screens/loggingin/signIn.dart';

import '../../widgets/textfield.dart';
import '../../widgets/button.dart';

import '../../constants.dart';
import '../screens/messageScreen/messgeScreen.dart';

class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  var currentUserSnapshot;
  bool show = false;
  String downloadUrl = "";
  var result ;
  bool downloading = false;

  update() async {
    setState(() {
      show = false;
    });
    if (fileImage != null) {
      setState(() {
        showmessage("Processing Profile Image...");
      });
      try {
        setState(() {
          downloading = true;
        });
        await uploadImage();
        setState(() {
          downloading = false;
        });
      } catch (e) {
        showmessage(e.toString());
      }

      print("link is this $downloadUrl");
    }

    await FirebaseDatabase().updateProfilePicture(Constants.email,
        {"imageUrl": downloadUrl != "" ? downloadUrl : Constants.imageUrl});

    SavingFunction().savePicturePreference(
        downloadUrl != "" ? downloadUrl : Constants.imageUrl);
    showmessage("Profile Picture Updated");
    setState(() {
      fileImage = null;
    });
  }

  File? fileImage;

  getImage() async {
    var images =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      fileImage = File(images!.path);
      if(fileImage!=null){
      show = true;
      print(fileImage!.path.toString());
      print("hi");
    }
    });

  }

  uploadImage() async {
    final ref = await FirebaseStorage.instance
        .ref("profilepics/${fileImage!.path.toString()}");

     result = ref.putFile(fileImage!);

    setState(() {});

    if (result == null) return;

    final snapshot = await result;

    downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {});
    print('Download-Link: $downloadUrl');

    return downloadUrl;
  }
  getUser()async{
    currentUserSnapshot = await FirebaseDatabase().getUserByEmailSnapshots(Constants.email);
    setState(() {

    });
  }

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    signOut() async {
      await AuthServices().logOut();
      await SavingFunction().saveUserLoggedInPreference(false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: currentUserSnapshot!=null?Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    getImage();

                  },
                  child: Stack(

                    children: [
                      Stack(
                        children: [
                          ClipOval(
                            child: SizedBox(
                                width: 200,
                                height: 200,
                                child: (fileImage != null)
                                    ? Image.file(
                                        fileImage!,
                                        fit: BoxFit.cover,
                                      )
                                    :
                                StreamBuilder<
                                            QuerySnapshot<Map<String, dynamic>>>(
                                        stream: currentUserSnapshot,
                                        builder: (context, snapshot) {
                                          return
                                              snapshot.hasData?
                                              snapshot.data?.docs[0]["imageUrl"] !=""? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                               snapshot.data?.docs[0]["imageUrl"]),
                                            radius: 14,
                                          ):CircleAvatar(
                                                backgroundColor: Kcolors[Random().nextInt(Kcolors.length)],
                                                child: Text(snapshot.data?.docs[0]["name"][0],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 50
                                                ),),
                                                radius: 14,
                                              )

                                          : Container();
                                        })),
                          ),
                          downloading?SizedBox(
                              height: 200,
                              width: 200,

                              child: CircularProgressIndicator(


                                backgroundColor: Colors.cyanAccent,



                              ),
                          ):SizedBox(),
                          // downloading?showProgress(result):SizedBox(),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(

                              radius: 32,

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                               Icon(Icons.image),
                                  const Text(
                                    "Update",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),

                          // SizedBox(
                          //     height:205,
                          //     width:205,child: CircularProgressIndicator())


                        ],
                      ),

                    ],

                  ),
                ),
              ),
              show
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () async {
                          await update();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 200,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: KprimaryColor,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Update Profile Picture"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 20,
              ),
              Text(

                Constants.name,
                style: TextStyle(fontSize: 24),
              ),
              Text(
                "(${Constants.email})",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(28.0),
            child: InkWell(
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pop(context);

                          await signOut();
                        },
                        child: const Text(
                          'YES',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('NO', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                );
              },
              onLongPress: () {},
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: KprimaryColor,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
                      Text("Log Out "),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ):Container()),
    );
  }
  Widget showProgress(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return SizedBox(
              height: 200,
              width: 200,

              child: CircularProgressIndicator(


                backgroundColor: Colors.cyanAccent,

                value: progress,
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
