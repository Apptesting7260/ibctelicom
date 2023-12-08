import 'package:flutter/material.dart';
import 'package:nauman/UI%20Components/button.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'package:nauman/UI%20Components/textDesign.dart';
import 'package:nauman/UI%20Components/textField.dart';

class InviteFriendsClass extends StatefulWidget {
  @override
  State<InviteFriendsClass> createState() => _InviteFriendsClassState();
}

class _InviteFriendsClassState extends State<InviteFriendsClass> {
  TextEditingController friendNameController = TextEditingController();
  TextEditingController friendEmailController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    friendEmailController.dispose();
    friendNameController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    }
    // Use a regular expression to validate the email format
    // This is a simple example, you might want to use a more robust regex
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                child: TextClass(
                  title: 'Invite Friends',
                  fontWeight: FontWeight.w700,
                  size: 18,
                  fontColor: Colors.black,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFieldClass(
                controller: friendNameController,
                hint: 'Name Your Friends',
                isObs: false,
                validator: _validateName,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldClass(
                controller: friendEmailController,
                hint: 'Enter Your Friends Email',
                isObs: false,
                validator: _validateEmail,
              ),
              const SizedBox(
                height: 40,
              ),
              Button(
                  textColor: Colors.white,
                  bgcolor: primaryLigtGreen,
                  title: 'Invite Friends',
                  onTap: () {
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid) {
                      print('Not valid');
                      return;
                    }
                    // formKey.currentState!.save();
                    print(friendEmailController.text);
                    print(friendNameController.text);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
