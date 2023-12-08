import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/models/color/color_modal.dart';

class LabelDropDownButton extends StatefulWidget {
  List<dynamic> items;
  String? selectedItem;
  String labelText;
  LabelDropDownButton(
      {required this.items,
      required this.selectedItem,
      required this.labelText});

  @override
  State<LabelDropDownButton> createState() => LabelDropDownButtonState();
}

class LabelDropDownButtonState extends State<LabelDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelStyle: TextStyle(
            color: lableDropDownCol, fontSize: 14, fontWeight: FontWeight.w500),
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pink),
          borderRadius: BorderRadius.circular(18.0),
        ),
        contentPadding: EdgeInsets.all(10),
      ),
      child: ButtonTheme(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              widget.items[0].toString(),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: widget.items == null
                ? List.empty()
                : widget.items
                    .map((item) => DropdownMenuItem<String>(
                          value: item.toString(),
                          child: Text(
                            item.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
            value: widget.selectedItem,
            onChanged: (value) {
              setState(() {
                widget.selectedItem = value;
              });
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: Get.width,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}
