import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/alt_profile/alt_profile.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();
  TextEditingController updateCaptionController = TextEditingController();
  String? imageTimePosted;

  String? get getImageTimePosted => imageTimePosted;

  showTimeAgo(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username':
          Provider.of<FireBaseOperations>(context, listen: false).initUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage':
          Provider.of<FireBaseOperations>(context, listen: false).initUserImage,
      'useremail':
          Provider.of<FireBaseOperations>(context, listen: false).initUserEmail,
      'time': Timestamp.now(),
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username':
          Provider.of<FireBaseOperations>(context, listen: false).initUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage':
          Provider.of<FireBaseOperations>(context, listen: false).initUserImage,
      'useremail':
          Provider.of<FireBaseOperations>(context, listen: false).initUserEmail,
      'time': Timestamp.now(),
    });
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                      child: Divider(
                          thickness: 4.0, color: constantColors.whiteColor),
                    ),
                    Container(
                      width: 100.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          'Comments',
                          style: TextStyle(
                            color: constantColors.blueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(docId)
                            .collection('comments')
                            .orderBy('time')
                            .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView(
                                children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                              Map<String, dynamic> data = documentSnapshot
                                  .data()! as Map<String, dynamic>;
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: GestureDetector(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              radius: 15.0,
                                              backgroundImage: NetworkImage(
                                                  data['userimage']),
                                            ),
                                            onTap: (){
                                              Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                  child: AltProfile(userUid: data['useruid'],),
                                                  type: PageTransitionType.bottomToTop,
                                                ),
                                              );
                                            }
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                              child: Text(
                                            data['username'],
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                FontAwesomeIcons.arrowUp,
                                                color:
                                                    constantColors.blueColor,
                                                size: 12,
                                              ),
                                            ),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                FontAwesomeIcons.reply,
                                                color: constantColors
                                                    .yellowColor,
                                                size: 12.0,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: constantColors.blueColor,
                                              size: 12.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                              data['comment'],
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.solidTrashAlt,
                                              color: constantColors.redColor,
                                              size: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList());
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 400.0,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 300.0,
                            height: 20.0,
                            child: TextField(
                              controller: commentController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: 'Add Comment...',
                                hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                              backgroundColor: constantColors.greenColor,
                              child: Icon(FontAwesomeIcons.comment,
                                  color: constantColors.whiteColor),
                              onPressed: () {
                                print('Adding Comments');
                                addComment(context, snapshot['caption'],
                                        commentController.text)
                                    .whenComplete(() {
                                  commentController.clear();
                                  notifyListeners();
                                });
                              })
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0),
                  ),
                ),
              ),
            ),
          );
        });
  }

  showLikes(BuildContext context, postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child:
                      Divider(thickness: 4.0, color: constantColors.whiteColor),
                ),
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.whiteColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Likes',
                      style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                            Map<String, dynamic> data = documentSnapshot.data()!
                                as Map<String, dynamic>;
                            return ListTile(
                                leading: GestureDetector(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(data['userimage']),
                                  ),
                                  onTap: (){
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        child: AltProfile(userUid: data['useruid'],),
                                        type: PageTransitionType.bottomToTop,
                                      ),
                                    );
                                  }
                                ),
                                title: Text(
                                  data['username'],
                                  style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                subtitle: Text(
                                  data['useremail'],
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                trailing: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        data['useruid']
                                    ? const SizedBox(
                                        height: 0.0,
                                        width: 0.0,
                                      )
                                    : MaterialButton(
                                        color: constantColors.blueColor,
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        onPressed: () {},
                                      ));
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled:true,
        context: context,
        builder: (context) {
          return Padding(
            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child:
                        Divider(thickness: 4.0, color: constantColors.whiteColor),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Edit Caption',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 300.0,
                                            height: 50.0,
                                            child: TextField(
                                              controller: updateCaptionController,
                                              decoration: InputDecoration(
                                                hintText: 'Add New Caption',
                                                hintStyle: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          FloatingActionButton(
                                            backgroundColor:
                                                constantColors.redColor,
                                            child: Icon(
                                              FontAwesomeIcons.fileUpload,
                                              color: constantColors.whiteColor,
                                            ),
                                            onPressed: () {
                                              Provider.of<FireBaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .updateCaption(postId, {
                                                'caption':
                                                    updateCaptionController.text,
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                        MaterialButton(
                          color: constantColors.redColor,
                          child: Text(
                            'Delete Post',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: constantColors.darkColor,
                                  title: Text(
                                    'Delete This Post? ',
                                    style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  actions: [
                                    MaterialButton(
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              constantColors.whiteColor,
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    MaterialButton(
                                      color: constantColors.redColor,
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        Provider.of<FireBaseOperations>(context,
                                                listen: false)
                                            .deleteUserData(postId,'posts')
                                            .whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
