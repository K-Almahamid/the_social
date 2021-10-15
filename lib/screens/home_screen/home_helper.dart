import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/services/firebase_operations.dart';

class HomeHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget bottomNavBar(
      BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (value) {
        index = value;
        pageController.jumpToPage(value);
        notifyListeners();
      },
      backgroundColor: const Color(0xff040307),
      items: [
        CustomNavigationBarItem(icon: const Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: const Icon(Icons.message_rounded)),
        CustomNavigationBarItem(
          icon: CircleAvatar(
            radius: 35.0,
            backgroundColor: constantColors.blueColor,
            backgroundImage: NetworkImage(
                '${Provider.of<FireBaseOperations>(context).initUserImage}'),
          ),
        )
      ],
    );
  }
}
