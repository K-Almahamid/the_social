import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  File? uploadPostImage;

  File? get getUploadPostImage => uploadPostImage;

  String? uploadPostImageUrl;

  String? get getUploadPostImageUrl => uploadPostImageUrl;

  final picker = ImagePicker();

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageValue = await picker.pickImage(source: source);
    uploadPostImageValue == null
        ? print("Select Image")
        : uploadPostImage = File(uploadPostImageValue.path);
    print(uploadPostImage!.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print('Image Upload Error');

    notifyListeners();
  }

  showPostImage(BuildContext context) {
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
                child:
                    Divider(thickness: 4.0, color: constantColors.whiteColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Container(
                  height: 200.0,
                  width: 400.0,
                  child: Image.file(uploadPostImage!, fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      child: Text(
                        'Reselect ',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor),
                      ),
                      onPressed: () {
                        selectPostImageType(context);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Confirm Image ',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        uploadImageToFirebase().whenComplete(() {
                          editPostSheet(context);
                          print('Image Uploaded and button work');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child:
                    Divider(thickness: 4.0, color: constantColors.whiteColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Gallery ',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () {
                      pickUploadPostImage(context, ImageSource.gallery);
                    },
                  ),
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Camera ',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () {
                      pickUploadPostImage(context, ImageSource.camera);
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  TextEditingController captionController = TextEditingController();

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.90,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12.0),
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
                    children: [
                      Container(
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.image_aspect_ratio,
                                    color: constantColors.greenColor)),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.fit_screen,
                                color: constantColors.yellowColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 200.0,
                        width: 300.0,
                        child: Image.file(
                          uploadPostImage!,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Image.asset('assets/images/sunflower.png'),
                      ),
                      Container(
                        height: 110.0,
                        width: 5.0,
                        color: constantColors.blueColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 280,
                          child: TextField(
                            maxLines: 5,
                            maxLength: 100,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            controller: captionController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Add A Caption...',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    'Share ',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  onPressed: () async {
                    Provider.of<FireBaseOperations>(context, listen: false)
                        .uploadPostData(captionController.text, {
                          'postimage': getUploadPostImageUrl,
                          'caption': captionController.text,
                          'username': Provider.of<FireBaseOperations>(context,
                                  listen: false)
                              .initUserName,
                          'userimage': Provider.of<FireBaseOperations>(context,
                                  listen: false)
                              .initUserImage,
                          'useruid': Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid,
                          'time': Timestamp.now(),
                          'useremail': Provider.of<FireBaseOperations>(context,
                                  listen: false)
                              .initUserEmail,
                        })
                        .whenComplete(() => FirebaseFirestore.instance
                                .collection('users')
                                .doc(Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid)
                                .collection('posts')
                                .add({
                              'postimage': getUploadPostImageUrl,
                              'caption': captionController.text,
                              'username': Provider.of<FireBaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserName,
                              'userimage': Provider.of<FireBaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserImage,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'time': Timestamp.now(),
                              'useremail': Provider.of<FireBaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserEmail,
                            }))
                        .whenComplete(() {
                          Navigator.pop(context);
                        });
                  },
                )
              ],
            ),
          );
        });
  }

  UploadTask? imagePostUploadTask;

  Future uploadImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage!.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage!);
    await imagePostUploadTask!.whenComplete(() {
      print('Post Image Uploaded To Storage');
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print('Post Image URl => $uploadPostImageUrl');
      notifyListeners();
    });
  }
}
