import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/landing_screen/landing_helpers.dart';

class LandingScreen extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColor(),
        Provider.of<LandingHelpers>(context,listen: false).bodyImage(context),
        Provider.of<LandingHelpers>(context,listen: false).taglineText(context),
        Provider.of<LandingHelpers>(context,listen: false).mainButton(context),
        Provider.of<LandingHelpers>(context,listen: false).privacyText(context),
        ],
      ),
    );
  }

  bodyColor() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
            0.5,
            0.9
          ],
              colors: [
            constantColors.darkColor,
            constantColors.blueGreyColor,
          ])),
    );
  }
}
