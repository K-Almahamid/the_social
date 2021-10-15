import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/alt_profile/alt_profile.dart';
import 'package:the_social/screens/home_screen/home_screen.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:the_social/utils/post_options.dart';

class AltProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
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
              type: PageTransitionType.bottomToTop,
            ),
          );
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            EvaIcons.moreVertical,
            color: constantColors.whiteColor,
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
      ],
      title: RichText(
        text: TextSpan(
            text: 'The',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' Social',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ]),
      ),
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.37,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: constantColors.transparent,
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              (snapshot.data as dynamic)['userimage']),
                        ),
                        onTap: () {}),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                          child: Text(
                            (snapshot.data as dynamic)['username'],
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                EvaIcons.email,
                                color: constantColors.greenColor,
                                size: 16.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  (snapshot.data as dynamic)['useremail'],
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  checkFollowersSheet(context, snapshot);
                                },
                                child: SizedBox(
                                  height: 60.0,
                                  width: 70.0,
                                  child: Column(
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc((snapshot.data
                                                as dynamic)['useruid'])
                                            .collection('followers')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return const Text(
                                                'Something went wrong');
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      Text(
                                        'Followers',
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //const SizedBox(width: 15.0),
                              SizedBox(
                                // margin:const EdgeInsets.all(5.0),
                                // decoration: BoxDecoration(
                                //   color: constantColors.darkColor,
                                //   borderRadius: BorderRadius.circular(15.0),
                                // ),
                                height: 60.0,
                                width: 70.0,
                                child: Column(
                                  children: [
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc((snapshot.data
                                              as dynamic)['useruid'])
                                          .collection('following')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              'Something went wrong');
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              snapshot.data!.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //const SizedBox(width: 15.0),
                              SizedBox(
                                // margin:const EdgeInsets.all(5.0),
                                // decoration: BoxDecoration(
                                //   color: constantColors.darkColor,
                                //   borderRadius: BorderRadius.circular(15.0),
                                // ),
                                height: 60.0,
                                width: 70.0,
                                child: Column(
                                  children: [
                                    Text(
                                      '0',
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      'Posts',
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Follow ',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () {
                      Provider.of<FireBaseOperations>(context, listen: false)
                          .followUser(
                        userUid,
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid!,
                        {
                          'username': Provider.of<FireBaseOperations>(context,
                                  listen: false)
                              .initUserName,
                          'userimage': Provider.of<FireBaseOperations>(context,
                                  listen: false)
                              .initUserImage,
                          'useruid': Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid,
                          'useremail': Provider.of<FireBaseOperations>(context,
                                  listen: false)
                              .initUserEmail,
                          'time': Timestamp.now(),
                        },
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid!,
                        userUid,
                        {
                          'username': (snapshot.data as dynamic)['username'],
                          'userimage': (snapshot.data as dynamic)['userimage'],
                          'useremail': (snapshot.data as dynamic)['useremail'],
                          'useruid': (snapshot.data as dynamic)['useruid'],
                          'time': Timestamp.now(),
                        },
                      )
                          .whenComplete(() {
                        followedNotification(
                            context, (snapshot.data as dynamic)['username']);
                      });
                    },
                  ),
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Message ',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25.0,
        width: 350.0,
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Provider.of<Authentication>(context, listen: false).getUserUid !=
              (snapshot.data as dynamic)['useruid']
              ? const SizedBox(
            width: 0.0,
            height: 0.0,
          )
              :
          Container(
            width: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  FontAwesomeIcons.userAstronaut,
                  color: constantColors.yellowColor,
                  size: 16.0,
                ),
                Text(
                  'Recently Added',
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
          Provider.of<Authentication>(context, listen: false).getUserUid !=
              (snapshot.data as dynamic)['useruid']
              ? const SizedBox(
            width: 0.0,
            height: 0.0,
          )
              :
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // child: Image.asset('assets/images/empty.png'),
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data['useruid'])
              .collection('posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    return GestureDetector(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.network(
                            documentSnapshot['postimage'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: (){
                        showPostDetails(context, documentSnapshot);
                      },
                    );
                  }).toList());
            }
          },
        ),
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                        thickness: 4.0, color: constantColors.whiteColor),
                  ),
                  Text(
                    'Followed $name ',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  checkFollowersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc((snapshot.data as dynamic)['useruid'])
                .collection('followers')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot documentSnapshot) {
                  Map<String, dynamic> data =
                      documentSnapshot.data()! as Map<String, dynamic>;
                  return ListTile(
                    onTap: () {
                      if (data['useruid'] !=
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid) {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: AltProfile(
                              userUid: data['useruid'],
                            ),
                            type: PageTransitionType.leftToRight,
                          ),
                        );
                      }
                    },
                    trailing: data['useruid'] ==
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid
                        ? const SizedBox(width: 0.0, height: 0.0)
                        : MaterialButton(
                            color: constantColors.blueColor,
                            child: Text(
                              'Unfollow',
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: () {},
                          ),
                    leading: CircleAvatar(
                      backgroundColor: constantColors.darkColor,
                      backgroundImage: NetworkImage(data['userimage']),
                    ),
                    title: Text(
                      data['username'],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      data['useremail'],
                      style: TextStyle(
                        color: constantColors.yellowColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  );
                }).toList());
              }
            },
          ),
        );
      },
    );
  }

  showPostDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image.network(documentSnapshot['postimage']),
                ),
              ),
              Text(
                documentSnapshot['caption'],
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.heart,
                            color: constantColors.redColor,
                            size: 22.0,
                          ),
                          onTap: () {
                            print('Adding Like ... ');
                            Provider.of<PostFunctions>(context, listen: false)
                                .addLike(
                              context,
                              documentSnapshot['caption'],
                              Provider.of<Authentication>(context,
                                  listen: false)
                                  .getUserUid!,
                            );
                          },
                          onLongPress: () {
                            Provider.of<PostFunctions>(context, listen: false)
                                .showLikes(context, documentSnapshot['caption']);
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(documentSnapshot['caption'])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                );
                              }
                            })
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: constantColors.blueColor,
                            size: 22.0,
                          ),
                          onTap: () {
                            Provider.of<PostFunctions>(context, listen: false)
                                .showCommentsSheet(
                                context, documentSnapshot, documentSnapshot['caption']);
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(documentSnapshot['caption'])
                                .collection('comments')
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
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                );
                              }
                            })
                      ],
                    ),
                  ),
                  const Spacer(),
                  Provider.of<Authentication>(context, listen: false)
                      .getUserUid ==
                      documentSnapshot['useruid']
                      ? IconButton(
                    onPressed: () {
                      Provider.of<PostFunctions>(context, listen: false)
                          .showPostOptions(context, documentSnapshot['caption']);
                    },
                    icon: Icon(EvaIcons.moreVertical,
                        color: constantColors.whiteColor),
                  )
                      : const SizedBox(
                    width: 0.0,
                    height: 0.0,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
