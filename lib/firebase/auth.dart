import 'package:firebase_auth/firebase_auth.dart';
import '../model/users.dart';

class AuthServices {
  Users? _users(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? Users(id: user.uid) : null;
  }
  final FirebaseAuth _auth =  FirebaseAuth.instance;

  signIn(email, password) async {
    final FirebaseAuth _auth =  FirebaseAuth.instance;

    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password) as UserCredential;
    User? user = result.user;
    return _users(user!);


  }

  signUp(email, password) async {


    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password) as UserCredential;
    User? user = result.user;
    return _users(user!);

  }


  resetPassword(email) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.sendPasswordResetEmail(email: email);
  }
  logOut()async{
    await _auth.signOut();
  }
  // signInWithGoogle()async{
  //   await _auth.signInWith
  // }
}
