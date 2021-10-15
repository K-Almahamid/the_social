import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/alt_profile/alt_profile.dart';
import 'package:the_social/screens/messaging/group_message.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomHelper with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController chatRoomNameController = TextEditingController();
  String? chatroomAvatarUrl, chatroomID;

  String? get getChatroomAvatarUrl => chatroomAvatarUrl;

  String? get getChatroomID => chatroomID;

  String? latestMessageTime;

  String? get getLatestMessageTime => latestMessageTime;

  showCreateChatRoomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: 4.0,
                    ),
                  ),
                  Text(
                    'Select Chatroom Avatar',
                    style: TextStyle(
                      color: constantColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomIcons')
                          .doc('images')
                          .collection('image')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: chatroomAvatarUrl ==
                                                documentSnapshot['image']
                                            ? constantColors.blueColor
                                            : constantColors.transparent)),
                                child: GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14.0, right: 14.0),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          constantColors.transparent,
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(
                                          documentSnapshot['image']),
                                    ),
                                  ),
                                  onTap: () {
                                    chatroomAvatarUrl =
                                        documentSnapshot['image'];

                                    print(chatroomAvatarUrl);
                                    notifyListeners();
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: chatRoomNameController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Chatroom ID',
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: constantColors.blueGreyColor,
                        child: Icon(
                          EvaIcons.plus,
                          color: constantColors.yellowColor,
                          size: 30.0,
                        ),
                        onPressed: () async {
                          Provider.of<FireBaseOperations>(context,
                                  listen: false)
                              .submitChatroomData(
                            chatRoomNameController.text,
                            {
                              'roomavatar': getChatroomAvatarUrl,
                              'time': Timestamp.now(),
                              'roomname': chatRoomNameController.text,
                              'username': Provider.of<FireBaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserName,
                              'useremail': Provider.of<FireBaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserEmail,
                              'userimage': Provider.of<FireBaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserImage,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                            },
                          ).whenComplete(() {
                            FirebaseFirestore.instance
                                .collection('chatrooms')
                                .doc(chatRoomNameController.text)
                                .collection('messages')
                                .add({
                              'message': 'No Messages',
                              'time': Timestamp.now(),
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'username': Provider.of<FireBaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserName,
                              'userimage': Provider.of<FireBaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserImage,
                            });
                          }).whenComplete(() {
                            chatRoomNameController.text = '';
                            Navigator.pop(context);
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  showChatRooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatrooms')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(
            height: 200.0,
            width: 200.0,
            child: Lottie.asset('assets/animations/loading.json'),
          ));
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ListView(
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                  title: Text(
                    documentSnapshot['roomname'],
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(documentSnapshot.id)
                          .collection('messages')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.data!.docs.first['username'] !=
                                null &&
                            snapshot.data!.docs.first['message'] != null) {
                          return Text(
                            '${snapshot.data!.docs.first['username']} : ${snapshot.data!.docs.first['message']}',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (snapshot.data!.docs.first['username'] !=
                                null &&
                            snapshot.data!.docs.first['sticker'] != null) {
                          return Text(
                            '${snapshot.data!.docs.first['username']} : Sticker ',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const SizedBox(height: 0.0, width: 0.0);
                        }
                      }),
                  leading: CircleAvatar(
                    backgroundColor: constantColors.transparent,
                    radius: 30.0,
                    backgroundImage:
                        NetworkImage(documentSnapshot['roomavatar']),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: GroupMessage(documentSnapshot: documentSnapshot),
                        type: PageTransitionType.leftToRight,
                      ),
                    );
                  },
                  onLongPress: () {
                    showChatRoomDetails(context, documentSnapshot);
                  },
                  trailing: SizedBox(
                    width: 80.0,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatrooms')
                            .doc(documentSnapshot.id)
                            .collection('messages')
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          showLastMessageTime(
                              snapshot.data!.docs.first['time']);
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Lottie.asset(
                                    'assets/animations/loading.json'));
                          } else {
                            return Text(
                              getLatestMessageTime!,
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        }),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }

  showChatRoomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: 4.0,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.blueColor),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Members',
                      style: TextStyle(
                        color: constantColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(documentSnapshot.id)
                          .collection('members')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: GestureDetector(
                                  child: CircleAvatar(
                                    backgroundColor: constantColors.darkColor,
                                    backgroundImage: NetworkImage(
                                        documentSnapshot['userimage']),
                                  ),
                                  onTap: () {
                                    if (Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid !=
                                        documentSnapshot['useruid']) {
                                      Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          child: AltProfile(
                                              userUid:
                                                  documentSnapshot['useruid']),
                                          type: PageTransitionType.bottomToTop,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        }
                      }),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.yellowColor),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        color: constantColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transparent,
                        backgroundImage:
                            NetworkImage(documentSnapshot['userimage']),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              documentSnapshot['username'],
                              style: TextStyle(
                                color: constantColors.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Provider.of<Authentication>(context, listen: false)
                                      .getUserUid ==
                                  documentSnapshot['useruid']
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: MaterialButton(
                                    color: constantColors.redColor,
                                    child: Text(
                                      'Delete Room',
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      deleteRoom(context, documentSnapshot);
                                    },
                                  ),
                                )
                              : const SizedBox(width: 0.0, height: 0.0)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  deleteRoom(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Delete ChatRoom?',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          actions: [
            MaterialButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  decoration: TextDecoration.underline,
                  decorationColor: constantColors.whiteColor,
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
                  fontSize: 18.0,
                ),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(documentSnapshot.id)
                    .delete()
                    .whenComplete(
                  () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    notifyListeners();
  }
}
