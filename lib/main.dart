import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/constant_colors.dart';
import 'package:the_social/screens/alt_profile/alt_profile_helper.dart';
import 'package:the_social/screens/chat_room_screen/chat_room_helpers.dart';
import 'package:the_social/screens/feed_screen/feed_helpers.dart';
import 'package:the_social/screens/home_screen/home_helper.dart';
import 'package:the_social/screens/landing_screen/landing_helpers.dart';
import 'package:the_social/screens/landing_screen/landing_services.dart';
import 'package:the_social/screens/landing_screen/landing_utils.dart';
import 'package:the_social/screens/messaging/group_message_helper.dart';
import 'package:the_social/screens/profile_screen/profile_helpers.dart';
import 'package:the_social/screens/splash_screen/splash_screen.dart';
import 'package:the_social/screens/stories/stories_helper.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:the_social/utils/post_options.dart';
import 'package:the_social/utils/upload_post.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoriesHelper()),
        ChangeNotifierProvider(create: (_) => GroupMessageHelper()),
        ChangeNotifierProvider(create: (_) => ChatRoomHelper()),
        ChangeNotifierProvider(create: (_) => AltProfileHelper()),
        ChangeNotifierProvider(create: (_) => PostFunctions()),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => ProfileHelpers()),
        ChangeNotifierProvider(create: (_) => HomeHelper()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => FireBaseOperations()),
        ChangeNotifierProvider(create: (_) => LandingServices()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingHelpers()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: ThemeData(
          accentColor: constantColors.blueColor,
          fontFamily: 'Poppins',
          canvasColor: Colors.transparent,
        ),
      ),
    );
  }
}
