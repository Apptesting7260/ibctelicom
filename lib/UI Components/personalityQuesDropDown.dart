import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';

class PersonalityQuesDropDown extends StatefulWidget {
  List<String> questions;
  String? Function(String?)? validator;
  // String? selectedValue;
  PersonalityQuesDropDown({
    required this.questions,
    required this.validator,
    // required this.selectedValue
  });
  @override
  State<PersonalityQuesDropDown> createState() =>
      PersonalityQuesDropDownState();
}

class PersonalityQuesDropDownState extends State<PersonalityQuesDropDown> {
  String? value;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      validator: widget.validator,
      isExpanded: true,
      isDense: true,
      style: TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      hint: Text(
        'Select a option',
        style: TextStyle(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
      ),
      items: widget.questions
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      value: value,
      onChanged: (String? value) {
        setState(() {
          value = value;
        });
      },
      buttonStyleData: ButtonStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 20,
        width: Get.width,
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
      ),
      iconStyleData: IconStyleData(
          icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: primaryDark,
      )),
    );
  }
}
