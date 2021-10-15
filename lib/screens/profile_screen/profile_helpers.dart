import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/alt_profile/alt_profile.dart';
import 'package:the_social/screens/landing_screen/landing_screen.dart';
import 'package:the_social/screens/stories/stories_widgets.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/utils/post_options.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final StoryWidgets storyWidgets = StoryWidgets();

  Widget headerProfile(BuildContext context, AsyncSnapshot snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.39,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: constantColors.transparent,
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(
                                      (snapshot.data as dynamic)['userimage']),
                                ),
                                Positioned(
                                  top: 76.0,
                                  left: 70.0,
                                  child: Icon(
                                    FontAwesomeIcons.plusCircle,
                                    color: constantColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              storyWidgets.addStory(context);
                            },
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 15.0),
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
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 15.0),
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
                                padding: const EdgeInsets.only(
                                    top: 30.0, left: 15.0),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      snapshot.data!.docs.length
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25.0,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            Text(
                                              'Followers',
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        checkFollowingSheet(context, snapshot);
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      snapshot.data!.docs.length
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25.0,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            Text(
                                              'Following',
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60.0,
                                      width: 70.0,
                                      child: Column(
                                        children: [
                                          Text(
                                            '0',
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25.0,
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
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserUid)
                  .collection('highlights')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot documentSnapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: GestureDetector(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: constantColors.darkColor,
                                  radius: 25.0,
                                  backgroundImage:
                                      NetworkImage(documentSnapshot['cover']),
                                ),
                                Text(
                                  documentSnapshot['title'],
                                  style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            storyWidgets.previewHighlights(
                              context,
                              documentSnapshot['title'],
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
              },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: constantColors.darkColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc((snapshot.data as dynamic)['useruid'])
                        .collection('following')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              Map<String, dynamic> data = documentSnapshot
                                  .data()! as Map<String, dynamic>;
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 60.0,
                                    width: 60.0,
                                    child: CircleAvatar(
                                      backgroundColor: constantColors.darkColor,
                                      backgroundImage:
                                          NetworkImage(data['userimage']),
                                    ),
                                  ),
                                );
                              }
                            }).toList());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.darkColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .
              // doc(snapshot.data['useruid']).
              doc(Provider.of<Authentication>(context, listen: false)
                  .getUserUid)
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
                      onTap: () {
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

  logOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Log Out?',
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
                Provider.of<Authentication>(context, listen: false)
                    .logOutViaEmail()
                    .whenComplete(() {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: LandingScreen(),
                        type: PageTransitionType.bottomToTop),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
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
                .collection('following')
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
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: AltProfile(
                            userUid: data['useruid'],
                          ),
                          type: PageTransitionType.topToBottom,
                        ),
                      );
                    },
                    trailing: MaterialButton(
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
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: AltProfile(
                            userUid: data['useruid'],
                          ),
                          type: PageTransitionType.topToBottom,
                        ),
                      );
                    },
                    trailing: MaterialButton(
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
                                .showLikes(
                                    context, documentSnapshot['caption']);
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
                                .showCommentsSheet(context, documentSnapshot,
                                    documentSnapshot['caption']);
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
                                .showPostOptions(
                                    context, documentSnapshot['caption']);
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
