import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

ThemeData lightThemeData (BuildContext context){
   return ThemeData.light().copyWith(
     primaryColor: KprimaryColor,
     scaffoldBackgroundColor: Colors.white,
textTheme: GoogleFonts.interTextTheme(
  Theme.of(context).textTheme.apply(
    bodyColor: KcontentLightTheme
  )
),
     bottomNavigationBarTheme: BottomNavigationBarThemeData(

         backgroundColor: Colors.white,

         selectedItemColor: KprimaryColor,
         unselectedItemColor: KcontentLightTheme.withOpacity(0.6)

     ),
     iconTheme: IconThemeData(
       color: KcontentLightTheme),
     colorScheme: ColorScheme.light(
       primary: KprimaryColor,
       secondary: KsecondaryColor,
       error: kErrorColor,
     ),
   );

}
ThemeData darkThemeData (BuildContext context){
  return ThemeData.dark().copyWith(
    textTheme: GoogleFonts.interTextTheme(
        Theme.of(context).textTheme.apply(
            bodyColor: KContentDarkTheme
        )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(

    backgroundColor: KcontentLightTheme,

      selectedItemColor: KprimaryColor,
      unselectedItemColor: KContentDarkTheme.withOpacity(0.6)

    ),
    primaryColor: KprimaryColor,
    scaffoldBackgroundColor: Color(0xff0E1E2B),

    iconTheme: IconThemeData(
        color: KContentDarkTheme),
    colorScheme: ColorScheme.light(
      primary: KprimaryColor,
      secondary: KsecondaryColor,
      error: kErrorColor,
    ),
  );

}