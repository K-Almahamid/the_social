import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/stories/stories_widgets.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoriesHelper with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  UploadTask? imageUploadTask;
  final picker = ImagePicker();
  File? storyImage;

  File? get getStoryImage => storyImage;
  String? storyImageUrl, storyHighlightIcon, storyTime, lastSeenTime;

  String? get getStoryImageUrl => storyImageUrl;

  String? get getStoryTime => storyTime;

  String? get getLastSeenTime => lastSeenTime;

  String? get getStoryHighlightIcon => storyHighlightIcon;

  final StoryWidgets storyWidgets = StoryWidgets();

  Future selectStoryImage(BuildContext context, ImageSource source) async {
    final pickedStoryImage = await picker.pickImage(source: source);
    pickedStoryImage == null
        ? print('error')
        : storyImage = File(pickedStoryImage.path);

    storyImage != null
        ? storyWidgets.previewStoryImage(context, storyImage!)
        : print('storyImage error');
    notifyListeners();
  }

  Future uploadStoryImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('stories/${getStoryImage!.path}/${Timestamp.now()}');
    imageUploadTask = imageReference.putFile(getStoryImage!);

    await imageUploadTask!.whenComplete(() {
      print('Story Image Uploaded');
    });
    imageReference.getDownloadURL().then((url) {
      storyImageUrl = url;
      print('Story image url => $storyImageUrl');
      notifyListeners();
    });
  }

  Future convertHighlightedIcon(String firestoreImageUrl) async {
    storyHighlightIcon = firestoreImageUrl;
    print(storyHighlightIcon);
    notifyListeners();
  }

  Future addStoryToNewAlbum(BuildContext context, String userUid,
      String highlightName, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightName)
        .set({
      'title': highlightName,
      'cover': storyHighlightIcon,
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('highlights')
          .doc(highlightName)
          .collection('stories')
          .add({
        'image': getStoryImageUrl,
        'username': Provider.of<FireBaseOperations>(context, listen: false)
            .initUserName,
        'userimage': Provider.of<FireBaseOperations>(context, listen: false)
            .initUserImage,
      });
    });
  }

  Future addStoryToExistingAlbum(BuildContext context, String userUid,
      String highlightCollectionId, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightCollectionId)
        .collection('stories')
        .add({
      'image': storyImage,
      'username':
          Provider.of<FireBaseOperations>(context, listen: false).initUserName,
      'userimage':
          Provider.of<FireBaseOperations>(context, listen: false).initUserImage,
    });
  }

  storyTimePosted(dynamic timeData) {
    Timestamp timestamp = timeData;
    DateTime dateTime = timestamp.toDate();
    storyTime = timeago.format(dateTime);
    lastSeenTime = timeago.format(dateTime);
    notifyListeners();
  }

  Future addSeenStamp(BuildContext context, String storyId, String personId,
      DocumentSnapshot documentSnapshot) async {
    if (Provider.of<Authentication>(context, listen: false).getUserUid !=
        documentSnapshot['useruid']) {
      return FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .collection('seen')
          .doc(personId)
          .set({
        'time': Timestamp.now(),
        'username': Provider.of<FireBaseOperations>(context, listen: false)
            .initUserName,
        'userimage': Provider.of<FireBaseOperations>(context, listen: false)
            .initUserImage,
        'useruid':
            Provider.of<Authentication>(context, listen: false).getUserUid,
      });
    }
  }
}
