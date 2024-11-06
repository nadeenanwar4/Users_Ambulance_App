import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_ambulance_app/View/mainScreen.dart';
import 'package:users_ambulance_app/View/registerationScreen.dart';
import 'package:users_ambulance_app/AllWidgets/progressDialog.dart';
import 'package:users_ambulance_app/main.dart';
import 'package:users_ambulance_app/Refactoring/ButtonProperties.dart';

import '../Refactoring/button.dart';

class LoginScreen extends StatelessWidget
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left:15),
          child: Column(
            children: [
              const SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/Ambulance_logo_user.png"),
              ),

              const Text(
                "Login as a User",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Raleway',
                ),
              ),

              const SizedBox(height: 22,),

              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  hintText: "Enter your email address",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w300
                  ),



                ),

              ),

              const SizedBox(height: 15,),

              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                    color: Colors.black
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  labelStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w300
                  ),



                ),

              ),

              const SizedBox(height: 30,),

              CustomButon(text: 'Login', onTap: (){

                  if(emailTextEditingController.text.isEmpty)
                  {
                    Fluttertoast.showToast(msg: "Email address is Required");
                  }
                  else if(!emailTextEditingController.text.contains("@"))
                  {
                    Fluttertoast.showToast(msg: "Email address is not valid");
                  }else if(passwordTextEditingController.text.isEmpty)
                  {
                    Fluttertoast.showToast(msg: "Password is Required");
                  }
                  else
                  {
                    loginAndAuthenticateUser(context);
                  }

//Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen() ));



              },),
              const SizedBox(height: 4,),

              TextButton(
                child: const Text(
                  "Don't Have an Account ? | Regester Here",
                  style: TextStyle(
                    color: Colors.red,
                      fontFamily: 'Raleway',
                  ),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> registerationScreen() ));
                },
              ),

            ],

          ),
        ),

      ),

    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)
      {
        return ProgressDialog(message: "Authenticating, Please wait...");
      }
    );
    
    final User? firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errormsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errormsg.toString(), context);
    })).user;

    if(firebaseUser != null)
    {

      usersRef.child(firebaseUser.uid).once().then((snap){
        if(snap.snapshot != null)
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen() ));
            displayToastMessage("you are logged-in successfully.", context);
          }
        else
          {
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessage("No record exists for this user.", context);
            displayToastMessage("Please create new account.", context);
          }
      });
    }
    else
    {
      Navigator.pop(context);
      //error occured ;display error msg
      displayToastMessage("An Error occured, can not be signed-in.", context);
    }

  }
}

