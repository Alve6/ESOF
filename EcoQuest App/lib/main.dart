import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/pages/completed_quests_page.dart';
import 'package:namer_app/pages/bought_prizes_page.dart';
import 'package:namer_app/pages/leaderboard_page.dart';
import 'package:namer_app/pages/profile_edit_page.dart';
import 'package:namer_app/pages/profile_page.dart';
import 'package:namer_app/pages/settings_page.dart';
import 'package:permission_handler/permission_handler.dart';

import 'authentication/authentication.dart';
import 'helper/size_config.dart';
import 'services/notificationsAPI.dart';
import 'services/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final notificationPermission = await Permission.notification.status;
  if (notificationPermission.isDenied) {
    await Permission.notification.request();
  }
  NotificationsService().initNotification();

  runApp(EcoQuestApp());
}

class EcoQuestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      title: 'EcoQuest',
      theme: ThemeData(primarySwatch: Colors.green),
      home: AuthenticationPage(),
      routes: {
        'authentication_page': (context) => Authentication(),
        'profile_page': (context) => ProfilePage(),
        'profile_edit_page': (context) => ProfileEditPage(),
        'completed_quests_page': (context) => CompletedQuestsPage(),
        'bought_prizes_page': (context) => BoughtPrizesPage(),
        'leaderboard_page': (context) => LeaderboardPage(),
        'settings_page': (context) => SettingsPage(),
      },
    );
  }
}