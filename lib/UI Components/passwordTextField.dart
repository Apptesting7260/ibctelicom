import 'package:flutter/material.dart';
import 'package:nauman/UI%20Components/color.dart';

class PasswordTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  TextInputType? keyboardType;

  String? Function(String?)? validator;

  final Function? onChanged;

  PasswordTextFormField(
      {required this.controller,
      required this.labelText,
      required this.keyboardType,
      required this.onChanged,
      required this.validator});

  @override
  PasswordTextFormFieldState createState() => PasswordTextFormFieldState();
}

class PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? savedValue;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onChanged: (value) => widget.onChanged!(value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      cursorColor: primaryDark,
      keyboardType: widget.keyboardType,
      onSaved: (newValue) {
        savedValue = newValue;
      },
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CDD1D0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CDD1D0),
        ),
        labelStyle: TextStyle(
            fontSize: 14, color: primaryDark, fontWeight: FontWeight.w500),
        labelText: widget.labelText,
        suffixIcon: GestureDetector(
          onTap: _togglePasswordVisibility,
          child: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: _obscurePassword ? primaryDark : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
