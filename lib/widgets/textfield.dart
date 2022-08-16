import 'package:flutter/material.dart';

class NewTextArea extends StatelessWidget {
  const NewTextArea(
      {Key? key,
      required this.label,
        required this.controller,
      required this.iconData,
      required this.onChanged,
        this.autofocus = false,
         this.suffixData = const SizedBox(height: 1,width: 1,),
      this.show = false})
      : super(key: key);
  final String label;
  final bool autofocus;
  final Widget suffixData;
  final Widget iconData;
  final bool show;
  final TextEditingController controller;
  final String?Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        child: Row(


          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            iconData,
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextFormField(
                autofocus: autofocus,

                controller: controller,

                validator: onChanged,
                obscureText: show,

                decoration: InputDecoration(
                  suffixIcon: suffixData,

                    isDense: true,
                    labelText: label,

                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color)),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
