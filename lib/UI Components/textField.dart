import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';

class TextFieldClass extends StatefulWidget {
  String hint;
  bool isObs;
  TextInputType? keyboardType;
  TextEditingController controller;
  String? Function(String?)? validator;
  int? maxLines = 1;
  final Function? onChanged;
  // FormKey
  TextFieldClass(
      {required this.controller,
      required this.hint,
      required this.isObs,
      this.validator,
      this.onChanged,
      this.maxLines,
      this.keyboardType});

  @override
  State<TextFieldClass> createState() => TextFieldClassState();
}

class TextFieldClassState extends State<TextFieldClass> {
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   widget.controller.dispose();
  // }
  String? savedValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: widget.validator,
        onChanged: (value) => widget.onChanged!(value),
        // autovalidateMode: AutovalidateMode.always,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        maxLines: widget.isObs == false ? widget.maxLines : 1,
        inputFormatters: [new LengthLimitingTextInputFormatter(100)],
        cursorColor: primaryDark,
        obscureText: widget.isObs,
        keyboardType: widget.keyboardType != null
            ? widget.keyboardType
            : TextInputType.emailAddress,
        onSaved: (value) {
          savedValue = value;
        },
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CDD1D0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CDD1D0),
            ),
            enabled: true,
            labelStyle: TextStyle(
                fontSize: 14, color: primaryDark, fontWeight: FontWeight.w500),
            labelText: widget.hint));
  }
}
