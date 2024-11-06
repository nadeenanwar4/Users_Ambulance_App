import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../AllWidgets/progressDialog.dart';
import 'package:users_ambulance_app/View/mainScreen.dart';


class ButtonProperties {
  String? text;
  Color? color;
  double? width;
  double? height;
}
TextEditingController emailTextEditingController = TextEditingController();
TextEditingController passwordTextEditingController = TextEditingController();
TextEditingController nameTextEditingController = TextEditingController();
TextEditingController phoneTextEditingController = TextEditingController();



class ragisterationScreen extends ButtonProperties {
    BuildContext? context;

  void onPressed() {
    if(nameTextEditingController.text.length <3)
    {
      Fluttertoast.showToast(msg: "Name must be at least 3 characters");
    }
    else if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email address is not valid");
    }
    else if(phoneTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Phone number is required");
    }
    else if(passwordTextEditingController.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be at least 6 characters");
    }
    else
    {
      registerNewUser(context!);
    }
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
    {
      return ProgressDialog(message: "Registering, Please wait...");
    }
    );

  }
}

class LoginScreen extends ButtonProperties {
  BuildContext? context;



  void onLongPress() {
    if(emailTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Email address is Required");
    }
    else if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email address is not valid");
    }
    else if(passwordTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Password is Required");
    }
    else
    {
      loginAndAuthenticateUser(context!);
    }

    Navigator.push(context!, MaterialPageRoute(builder: (c)=> MainScreen() ));
  }
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
void loginAndAuthenticateUser(BuildContext context) async
{
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(message: "Authenticating, Please wait...");
      }
  );


    void main() {
      var button = LoginScreen();
      button.text = 'registerate';
      button.color = Colors.black;
      button.width = 100.0;
      button.height = 50.0;

      print(button.text); // Output: registerate
    }
  }
