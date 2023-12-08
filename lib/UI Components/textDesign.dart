import 'package:flutter/material.dart';

class TextClass extends StatefulWidget {
  String title;
  FontWeight fontWeight;
  double size;
  Color fontColor;
  TextAlign? align;
  TextClass(
      {required this.size,
      required this.fontWeight,
      required this.title,
      required this.fontColor,
      this.align});

  @override
  State<TextClass> createState() => _TextClassState();
}

class _TextClassState extends State<TextClass> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(
          fontWeight: widget.fontWeight,
          fontSize: widget.size,
          fontFamily: 'Poppins',
          color: widget.fontColor),
      softWrap: true,
      textAlign: widget.align,
    );
  }
}
