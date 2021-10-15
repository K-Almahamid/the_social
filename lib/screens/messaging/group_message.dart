import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/home_screen/home_screen.dart';
import 'package:the_social/screens/messaging/group_message_helper.dart';
import 'package:the_social/services/authentication.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  GroupMessage({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final ConstantColors constantColors = ConstantColors();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    Provider.of<GroupMessageHelper>(context, listen: false)
        .checkIfJoined(
      context,
      widget.documentSnapshot.id,
      widget.documentSnapshot['useruid'],
    )
        .whenComplete(() {
      if (Provider
          .of<GroupMessageHelper>(context, listen: false)
          .getHasMemberJoined ==
          false) {
        Timer(
          const Duration(milliseconds: 10),
              () =>
              Provider.of<GroupMessageHelper>(context, listen: false).askToJoin(
                context,
                widget.documentSnapshot.id,
              ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: HomeScreen(),
                type: PageTransitionType.leftToRight,
              ),
            );
          },
        ),
        title: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage:
                NetworkImage(widget.documentSnapshot['roomavatar']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.documentSnapshot['roomname'],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection(
                            'chatrooms')
                            .doc(widget.documentSnapshot.id)
                            .collection('members')
                            .snapshots(),
                        builder:(context,snapshot){
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          else {
                            return Text(
                              '${snapshot.data!.docs.length.toString()} members',
                              style: TextStyle(
                                color: constantColors.greenColor.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            );
                          }
                        }

                    )
                  ],
                ),
              )
            ],
          ),
        ),
        actions: [
          Provider
              .of<Authentication>(context, listen: false)
              .getUserUid ==
              widget.documentSnapshot['useruid']
              ? IconButton(
            icon: Icon(
              EvaIcons.moreVertical,
              color: constantColors.whiteColor,
            ),
            onPressed: () {},
          )
              : const SizedBox(
            width: 0.0,
            height: 0.0,
          ),
          IconButton(
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.redColor,
            ),
            onPressed: () {
              Provider.of<GroupMessageHelper>(context, listen: false).leaveTheRoom(context, widget.documentSnapshot.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedContainer(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.79,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              duration: const Duration(seconds: 1),
              curve: Curves.bounceIn,
              child: Provider.of<GroupMessageHelper>(context, listen: false)
                  .showMessages(context, widget.documentSnapshot,
                  widget.documentSnapshot['useruid']),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
                  left: 5.0,
                  right: 5.0),
              child: Row(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 18.0,
                      backgroundColor: constantColors.transparent,
                      backgroundImage:
                      const AssetImage('assets/images/sunflower.png'),
                    ),
                    onTap: (){
                      Provider.of<GroupMessageHelper>(context, listen: false).showStickers(context,widget.documentSnapshot.id);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.73,
                      child: TextField(
                        onTap: () {},
                        controller: messageController,
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Drop a hi...',
                          hintStyle: TextStyle(
                            color: constantColors.greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: constantColors.blueColor,
                    child: Icon(Icons.send_sharp,
                        color: constantColors.whiteColor),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        Provider.of<GroupMessageHelper>(context, listen: false)
                            .sendMessage(
                          context,
                          widget.documentSnapshot,
                          messageController,
                        );
                        messageController.text='';
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
