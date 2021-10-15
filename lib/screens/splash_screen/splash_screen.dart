import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/landing_screen/landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    Timer(
      const Duration(seconds: 1),
          () =>
          Navigator.pushReplacement(context, PageTransition(
            child:  LandingScreen(), type: PageTransitionType.leftToRight,),),);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'the',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>
              [
                TextSpan(
                  text: 'Social',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.blueColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
