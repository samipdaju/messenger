import 'package:flutter/material.dart';
class PrimaryButton extends StatelessWidget {

  final String text;
  final VoidCallback onPress;
  final EdgeInsets padding;
  final color;
  
  
  PrimaryButton({required this.text,required this.onPress,required this.color, required this.padding});


  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: onPress,
    child: Text(
      text,style: TextStyle(
      color: Colors.white,
      
    ),
      
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40)
    ),
    color: color,
        minWidth: double.infinity,
      padding: padding,
    );
  }
}
