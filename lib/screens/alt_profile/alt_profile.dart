import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/alt_profile/alt_profile_helper.dart';

class AltProfile extends StatelessWidget {
  final String userUid;

  AltProfile({Key? key, required this.userUid}) : super(key: key);
  final ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: Provider.of<AltProfileHelper>(context, listen: false).appBar(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor.withOpacity(0.6),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(18.0),
              topLeft: Radius.circular(18.0),
            ),
          ),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Provider.of<AltProfileHelper>(context, listen: false)
                            .headerProfile(context, snapshot, userUid),
                        Provider.of<AltProfileHelper>(context, listen: false)
                            .divider(),
                        Provider.of<AltProfileHelper>(context, listen: false)
                            .middleProfile(context, snapshot),
                        Provider.of<AltProfileHelper>(context, listen: false)
                            .footerProfile(context, snapshot),
                        const SizedBox(height:100.0),
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
