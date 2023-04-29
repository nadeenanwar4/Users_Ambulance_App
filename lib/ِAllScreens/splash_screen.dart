import 'dart:async';
import 'package:flutter/material.dart';
import 'package:users_ambulance_app/%D9%90AllScreens/loginScreen.dart';

class MySplashScreen extends StatefulWidget
{

  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}






class _MySplashScreenState extends State<MySplashScreen>
{
  startTimer()              //a method to determine how much time the splash screen gonna be displayed
  {
    // we put const modifier alongside with timer beacuse timer value is a constant which is 3 sec only
    Timer( const Duration(seconds: 3), () async
    {
      // a code to send user to home screen
      Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
    });

  }

  // the initstate is a built-in function in flutter : it is executed in the beginning of every page load
  // "seems like when it executes the page the user goes to starts to load then what comes inside this method starts to be executed ass well"
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        color: Colors.red.shade50,
        child: Center(
          // column widget because we will display an image and a text
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/splash_logo.png"),
              //const SizedBox(height: 3,),
              const Text(
                "مرحبا بك",
                style: TextStyle(
                    fontFamily: 'ElMessiri',
                    fontSize: 70,
                    color: Color(0xff851313),
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}