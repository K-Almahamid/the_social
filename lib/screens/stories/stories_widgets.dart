import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/alt_profile/alt_profile.dart';
import 'package:the_social/screens/home_screen/home_screen.dart';
import 'package:the_social/screens/stories/stories_helper.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';

class StoryWidgets {
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController storyHighlightTitleController =
      TextEditingController();

  previewStoryImage(BuildContext context, File storyImage) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
          ),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.file(storyImage),
              ),
              Positioned(
                top: 600.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'Reselect Image',
                        backgroundColor: constantColors.redColor,
                        child: Icon(
                          FontAwesomeIcons.backspace,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () {
                          addStory(context);
                        },
                      ),
                      FloatingActionButton(
                        heroTag: 'Confirm Image',
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () {
                          Provider.of<StoriesHelper>(context, listen: false)
                              .uploadStoryImage(context)
                              .whenComplete(() async {
                            try {
                              if (Provider.of<StoriesHelper>(context,
                                          listen: false)
                                      .getStoryImageUrl !=
                                  null) {
                                await FirebaseFirestore.instance
                                    .collection('stories')
                                    .doc(Provider.of<Authentication>(context,
                                            listen: false)
                                        .toString())
                                    .set({
                                  'image': Provider.of<StoriesHelper>(context,
                                          listen: false)
                                      .getStoryImageUrl,
                                  'useruid': Provider.of<Authentication>(
                                          context,
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
                                  'time': Timestamp.now(),
                                }).whenComplete(() {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      child: HomeScreen(),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                });
                              } else {
                                return showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: constantColors.darkColor),
                                      child: Center(
                                        child: MaterialButton(
                                          child: Text(
                                            'Upload Story!',
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('stories')
                                                .doc(
                                                    Provider.of<Authentication>(
                                                            context,
                                                            listen: false)
                                                        .toString())
                                                .set({
                                              'image':
                                                  Provider.of<StoriesHelper>(
                                                          context,
                                                          listen: false)
                                                      .getStoryImageUrl,
                                              'useruid':
                                                  Provider.of<Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserUid,
                                              'username': Provider.of<
                                                          FireBaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .initUserName,
                                              'userimage': Provider.of<
                                                          FireBaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .initUserImage,
                                              'time': Timestamp.now(),
                                            }).whenComplete(() {
                                              Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                  child: HomeScreen(),
                                                  type: PageTransitionType
                                                      .bottomToTop,
                                                ),
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  addStory(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
              ),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  color: constantColors.whiteColor,
                  thickness: 4,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () {
                      Provider.of<StoriesHelper>(context, listen: false)
                          .selectStoryImage(context, ImageSource.gallery)
                          .whenComplete(() {});
                    },
                  ),
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Camera',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () {
                      Provider.of<StoriesHelper>(context, listen: false)
                          .selectStoryImage(context, ImageSource.camera)
                          .whenComplete(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ]),
          );
        });
  }

  addToHighlights(BuildContext context, String storyImage) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: 4,
                  ),
                ),
                Text(
                  'Add To Existing Album',
                  style: TextStyle(
                    color: constantColors.yellowColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(Provider.of<Authentication>(context,listen: false).getUserUid)
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
                          children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
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
                                  Provider.of<StoriesHelper>(context, listen: false).addStoryToExistingAlbum(
                                      context,
                                    Provider.of<Authentication>(context, listen: false).getUserUid!,
                                      documentSnapshot.id,
                                      storyImage,
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
                Text(
                  'Create New Album',
                  style: TextStyle(
                    color: constantColors.greenColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Container(
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 8.0),
                              child: GestureDetector(
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  child:
                                      Image.network(documentSnapshot['image']),
                                ),
                                onTap: () {
                                  Provider.of<StoriesHelper>(context,
                                          listen: false)
                                      .convertHighlightedIcon(
                                          documentSnapshot['image']);
                                },
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: storyHighlightTitleController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add Album Title...',
                            hintStyle: TextStyle(
                              color: constantColors.blueColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () {
                          if (storyHighlightTitleController.text.isNotEmpty) {
                            Provider.of<StoriesHelper>(context, listen: false)
                                .addStoryToNewAlbum(
                              context,
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid!,
                              storyHighlightTitleController.text,
                              storyImage,
                            );
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    color: constantColors.redColor,
                                    height: 100,
                                    width: 400.0,
                                    child: Center(
                                      child: Text(
                                        'Add Album Title',
                                        style: TextStyle(
                                          color: constantColors.darkColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  );
                                });
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
      },
    );
  }

  showStoryViewers(BuildContext context, String storyId, String personId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  color: constantColors.whiteColor,
                  thickness: 4,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stories')
                      .doc(storyId)
                      .collection('seen')
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
                          Provider.of<StoriesHelper>(context, listen: false)
                              .storyTimePosted(documentSnapshot['time']);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: constantColors.darkColor,
                              radius: 25.0,
                              backgroundImage:
                                  NetworkImage(documentSnapshot['userimage']),
                            ),
                            title: Text(
                              documentSnapshot['username'],
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            subtitle: Text(
                              Provider.of<StoriesHelper>(context, listen: false)
                                  .getLastSeenTime!
                                  .toString(),
                              style: TextStyle(
                                color: constantColors.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.arrowAltCircleRight,
                                color: constantColors.yellowColor,
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    child: AltProfile(
                                        userUid: documentSnapshot['useruid']),
                                    type: PageTransitionType.bottomToTop,
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  previewHighlights(BuildContext context, String highlightTitle) {
    return showModalBottomSheet(
      backgroundColor: constantColors.darkColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
                .collection('highlights')
                .doc(highlightTitle)
                .collection('stories')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return PageView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: constantColors.darkColor
                      ),
                      child: Image.network(documentSnapshot['image']),
                    );
                  }).toList(),
                );
              }
            },
          ),
        );
      },
    );
  }
}
