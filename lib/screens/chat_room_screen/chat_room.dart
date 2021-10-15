import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/chat_room_screen/chat_room_helpers.dart';

class ChatRoom extends StatelessWidget {
final ConstantColors constantColors =ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueGreyColor,
        child: Icon(
          EvaIcons.plus,
          color: constantColors.greenColor,
          size: 30.0,
        ),
        onPressed: (){
          Provider.of<ChatRoomHelper>(context,listen: false).showCreateChatRoomSheet(context);
        },),
      appBar: AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            EvaIcons.plus,
            color: constantColors.greenColor,
            size: 30.0,
          ),
          onPressed: () {
            Provider.of<ChatRoomHelper>(context,listen: false).showCreateChatRoomSheet(context);
          },
        ),
        title:RichText(
        text: TextSpan(
            text: 'Chat ',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Box',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ]),
      ),
        actions: [
          IconButton(
            icon: Icon(
              EvaIcons.moreVertical,
              color: constantColors.whiteColor,
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:  Provider.of<ChatRoomHelper>(context,listen: false).showChatRooms(context),
      ),
    );
  }
}
