import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/home_screen/home_screen.dart';
import 'package:the_social/screens/stories/stories_helper.dart';
import 'package:the_social/screens/stories/stories_widgets.dart';
import 'package:the_social/services/authentication.dart';

class Stories extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  Stories({required this.documentSnapshot});

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final ConstantColors constantColors = ConstantColors();
  final StoryWidgets storyWidgets = StoryWidgets();

  @override
  void initState() {
    Provider.of<StoriesHelper>(context, listen: false)
        .storyTimePosted(widget.documentSnapshot['time']);
    Provider.of<StoriesHelper>(context, listen: false).addSeenStamp(
      context,
      widget.documentSnapshot.id,
      Provider.of<Authentication>(context, listen: false).getUserUid!,
      widget.documentSnapshot,
    );
    // Timer(
    //   const Duration(seconds: 15),
    //   () => Navigator.pushReplacement(
    //     context,
    //     PageTransition(
    //       child: HomeScreen(),
    //       type: PageTransitionType.bottomToTop,
    //     ),
    //   ),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: GestureDetector(
        onPanUpdate: (update) {
          if (update.delta.dx > 0) {
            print(update);
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: HomeScreen(),
                type: PageTransitionType.bottomToTop,
              ),
            );
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.documentSnapshot['image'],
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 30.0,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: constantColors.darkColor,
                        backgroundImage:
                            NetworkImage(widget.documentSnapshot['userimage']),
                        radius: 25.0,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.documentSnapshot['username'],
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            Provider.of<StoriesHelper>(context, listen: false)
                                .getStoryTime!,
                            style: TextStyle(
                              color: constantColors.greenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Provider.of<Authentication>(context, listen: false)
                                .getUserUid ==
                            widget.documentSnapshot['useruid']
                        ? GestureDetector(
                            child: SizedBox(
                              height: 30.0,
                              width: 60.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.solidEye,
                                    color: constantColors.yellowColor,
                                    size: 16.0,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('stories')
                                        .doc(widget.documentSnapshot.id)
                                        .collection('seen')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Something went wrong');
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              storyWidgets.showStoryViewers(
                                  context,
                                  widget.documentSnapshot.id,
                                  widget.documentSnapshot['useruid'],
                              );
                            },
                          )
                        : const SizedBox(width: 0.0, height: 0.0),
                    SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularCountDownTimer(
                        isTimerTextShown: false,
                        duration: 15,
                        fillColor: constantColors.blueColor,
                        height: 20.0,
                        width: 20.0,
                        ringColor: constantColors.darkColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        EvaIcons.moreVertical,
                        color: constantColors.whiteColor,
                      ),
                      onPressed: () {
                        showMenu(
                          color: constantColors.darkColor,
                          context: context,
                          position: const RelativeRect.fromLTRB(
                            300.0,
                            70.0,
                            0.0,
                            0.0,
                          ),
                          items: [
                            PopupMenuItem(
                              child: FlatButton.icon(
                                color: constantColors.blueColor,
                                onPressed: () {
                                  storyWidgets.addToHighlights(
                                    context,
                                    widget.documentSnapshot['image'],
                                  );
                                },
                                icon: Icon(
                                  FontAwesomeIcons.archive,
                                  color: constantColors.whiteColor,
                                ),
                                label: Text(
                                  'Add To Highlights',
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              child: FlatButton.icon(
                                color: constantColors.redColor,
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('stories')
                                      .doc(Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid)
                                      .delete()
                                      .whenComplete(() {
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        child: HomeScreen(),
                                        type: PageTransitionType.bottomToTop,
                                      ),
                                    );
                                  });
                                },
                                icon: Icon(
                                  FontAwesomeIcons.archive,
                                  color: constantColors.whiteColor,
                                ),
                                label: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
