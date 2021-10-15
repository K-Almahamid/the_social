import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/home_screen/home_screen.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelper with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  bool hasMemberJoined = false;

  bool get getHasMemberJoined => hasMemberJoined;
  String? lastMessageTime;

  String? get getLastMessageTime => lastMessageTime;

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username':
          Provider.of<FireBaseOperations>(context, listen: false).initUserName,
      'userimage':
          Provider.of<FireBaseOperations>(context, listen: false).initUserImage,
    });
  }

  showMessages(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUserUid) {
    return StreamBuilder<QuerySnapshot>(
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView(
            reverse: true,
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              showLastMessageTime(documentSnapshot['time']);
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: SizedBox(
                  height: documentSnapshot['message'] != null
                      ? MediaQuery.of(context).size.height * 0.125
                      : MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 20.0),
                        child: Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: documentSnapshot['message'] != null
                                    ? MediaQuery.of(context).size.height * 0.1
                                    : MediaQuery.of(context).size.height * 0.42,
                                maxWidth: documentSnapshot['message'] != null
                                    ? MediaQuery.of(context).size.width * 0.8
                                    : MediaQuery.of(context).size.width * 0.9,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot['useruid']
                                    ? constantColors.blueGreyColor
                                        .withOpacity(0.8)
                                    : constantColors.blueGreyColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 18.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Row(
                                        children: [
                                          Text(
                                            documentSnapshot['username'],
                                            style: TextStyle(
                                              color: constantColors.greenColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          Provider.of<Authentication>(context,
                                                          listen: false)
                                                      .getUserUid ==
                                                  adminUserUid
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Icon(
                                                    FontAwesomeIcons.chessKing,
                                                    color: constantColors
                                                        .yellowColor,
                                                    size: 12.0,
                                                  ),
                                                )
                                              : const SizedBox(
                                                  width: 0.0,
                                                  height: 0.0,
                                                ),
                                        ],
                                      ),
                                    ),
                                    documentSnapshot['message'] != null
                                        ? Text(
                                            documentSnapshot['message'],
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 14.0,
                                            ),
                                          )
                                        : SizedBox(
                                            height: 90.0,
                                            width: 100.0,
                                            child: Image.network(
                                                documentSnapshot['sticker']),
                                          ),
                                    SizedBox(
                                      width: 80.0,
                                      child: Text(
                                        getLastMessageTime!,
                                        style: TextStyle(
                                          color: constantColors.redColor,
                                          fontSize: 8.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          left: 20.0,
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid ==
                                  documentSnapshot['useruid']
                              ? Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        EvaIcons.editOutline,
                                        color: constantColors.blueColor,
                                        size: 18.0,
                                      ),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.trashAlt,
                                        color: constantColors.redColor,
                                        size: 18.0,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  height: 0.0,
                                  width: 0.0,
                                )),
                      Positioned(
                        left: 40.0,
                        child: Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid ==
                                documentSnapshot['useruid']
                            ? const SizedBox(
                                height: 0.0,
                                width: 0.0,
                              )
                            : CircleAvatar(
                                backgroundColor: constantColors.transparent,
                                backgroundImage:
                                    NetworkImage(documentSnapshot['userimage']),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future checkIfJoined(BuildContext context, String chatRoomName,
      String chatRoomAdminUid) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      print('initial state => $hasMemberJoined');
      if (value['joined'] != null) {
        hasMemberJoined = value['joined'];
        print('final state => $hasMemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context, String roomName) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Join $roomName?',
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
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  decoration: TextDecoration.underline,
                  decorationColor: constantColors.whiteColor,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: HomeScreen(),
                    type: PageTransitionType.bottomToTop,
                  ),
                );
              },
            ),
            MaterialButton(
              color: constantColors.redColor,
              child: Text(
                'Yes',
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(roomName)
                    .collection('members')
                    .doc(Provider.of<Authentication>(context, listen: false)
                        .getUserUid)
                    .set({
                  'joined': true,
                  'username':
                      Provider.of<FireBaseOperations>(context, listen: false)
                          .initUserName,
                  'userimage':
                      Provider.of<FireBaseOperations>(context, listen: false)
                          .initUserImage,
                  'useruid': Provider.of<Authentication>(context, listen: false)
                      .getUserUid,
                  'time': Timestamp.now(),
                }).whenComplete(() {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  showStickers(BuildContext context, String chatRoomId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
            height: MediaQuery.of(context).size.height * 0.5,
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
                  padding: const EdgeInsets.symmetric(horizontal: 105.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: constantColors.blueColor),
                        ),
                        child: Image.asset('assets/images/sunflower.png'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('stickers')
                          .doc('stickers')
                          .collection('sticker')
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
                          return GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  child: SizedBox(
                                    height: 40.0,
                                    width: 40.0,
                                    child: Image.network(
                                        documentSnapshot['sticker']),
                                  ),
                                  onTap: () {
                                    sendStickers(
                                        context,
                                        documentSnapshot['sticker'],
                                        chatRoomId);
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        }
                      }),
                )
              ],
            ),
          );
        });
  }

  sendStickers(
      BuildContext context, String stickerImageUrl, String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'sticker': stickerImageUrl,
      'username':
          Provider.of<FireBaseOperations>(context, listen: false).initUserName,
      'userimage':
          Provider.of<FireBaseOperations>(context, listen: false).initUserImage,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    notifyListeners();
  }

  leaveTheRoom(BuildContext context, String chatRoomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Leave $chatRoomName?',
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
                      .doc(chatRoomName)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .delete()
                      .whenComplete(
                    () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: HomeScreen(),
                            type: PageTransitionType.bottomToTop),
                      );
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}
