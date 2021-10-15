import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/home_screen/home_screen.dart';
import 'package:the_social/screens/landing_screen/landing_services.dart';
import 'package:the_social/screens/landing_screen/landing_utils.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/login.png')),
      ),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      top: 435.0,
      left: 10.0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 170.0),
        child: RichText(
          text: TextSpan(
              text: 'Are ',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'You ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.whiteColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Social ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.blueColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.whiteColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: 560.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                emailAuthSheet(context);
              },
              child: Container(
                child: Icon(EvaIcons.emailOutline,
                    color: constantColors.yellowColor),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: constantColors.yellowColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('signInWithGoogle');
                Provider.of<Authentication>(context, listen: false)
                    .signInWithGoogle()
                    .whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: HomeScreen(),
                        type: PageTransitionType.leftToRight,
                      ));
                })
                    .whenComplete(() => {
                  Provider.of<FireBaseOperations>(context,
                      listen: false)
                      .initUserData(context)
                });
              },
              child: Container(
                child: Icon(FontAwesomeIcons.google,
                    color: constantColors.redColor),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: constantColors.redColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Icon(FontAwesomeIcons.facebookF,
                    color: constantColors.blueColor),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: constantColors.blueColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      top: 630,
      left: 20.0,
      right: 20.0,
      child: Container(
        child: Column(
          children: [
            Text(
              "By continuing you agree theSocial's Terms of ",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
            ),
            Text(
              "Services & Privacy policy ",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child:
                    Divider(thickness: 4.0, color: constantColors.whiteColor),
              ),
              Provider.of<LandingServices>(context, listen: false)
                  .passwordLessSignIn(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      Provider.of<LandingServices>(context, listen: false)
                          .logInSheet(context);
                    },
                  ),
                  MaterialButton(
                    color: constantColors.redColor,
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      Provider.of<LandingUtils>(context, listen: false)
                          .selectAvatarOptionsSheet(context);
                    },
                  ),
                ],
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
        );
      },
    );
  }
}
