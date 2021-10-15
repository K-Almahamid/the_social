import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/chat_room_screen/chat_room.dart';
import 'package:the_social/screens/feed_screen/feed.dart';
import 'package:the_social/screens/home_screen/home_helper.dart';
import 'package:the_social/screens/profile_screen/profile.dart';
import 'package:the_social/services/firebase_operations.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConstantColors constantColors = ConstantColors();
  final PageController homePageController = PageController();
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    Provider.of<FireBaseOperations>(context,listen: false).initUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homePageController,
        physics: const NeverScrollableScrollPhysics(),
        children:  [
           Feed(),
          ChatRoom(),
          Profile(),
        ],
        onPageChanged: (page) {
          setState(
            () {
              pageIndex = page;
            },
          );
        },
      ),
      bottomNavigationBar: Provider.of<HomeHelper>(context, listen: false)
          .bottomNavBar(context,pageIndex, homePageController),
    );
  }
}
