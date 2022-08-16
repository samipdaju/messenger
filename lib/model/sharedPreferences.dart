import 'package:shared_preferences/shared_preferences.dart';

class SavingFunction{
 static String sharedPreferenceLogInKey ="isLoggedIn";
 static String sharedPreferenceEmailKey ="EMAILKEY";
 static String sharePreferenceUserNameKey= "USERNAMEKEY";
 static String sharePreferencePictureKey= "PICTUREKEY";

 saveUserLoggedInPreference(bool isUserLoggedIn)async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return preferences.setBool(sharedPreferenceLogInKey, isUserLoggedIn);
 }
 saveUserNamePreference(String userName)async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return preferences.setString(sharePreferenceUserNameKey, userName);

 }
 saveEmailPreference(String email)async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return preferences.setString(sharedPreferenceEmailKey, email);
 }
 savePicturePreference(String url)async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return preferences.setString(sharePreferencePictureKey, url);
 }
 getPicture()async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return preferences.getString(sharePreferencePictureKey);
 }

 getUserLoggedInPreference()async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return preferences.getBool(sharedPreferenceLogInKey);
 }
 getUserNamePreference()async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return preferences.getString(sharePreferenceUserNameKey, );

 }
 getEmailPreference()async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   return preferences.getString(sharedPreferenceEmailKey);
 }

}