import 'package:flutter/material.dart';

class FillInButton extends StatelessWidget {
  final Function() onPress;
  bool isFilled;
  final String text;

  FillInButton({
    required this.text,
    required this.onPress,
    this.isFilled = true,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: isFilled?4:0,
      onPressed: onPress,
      color: isFilled ? Colors.white : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white),

      ),
        child:Text(text,
        style: TextStyle(
          fontSize: 18,
          color: isFilled?Colors.black:Colors.white
        ),)
    );
  }
}
