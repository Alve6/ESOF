import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:namer_app/helper/size_config.dart';


class MainDrawer extends StatelessWidget {
  final String? name;
  final String? email;
  final String? profileImageURL;
  final int points;
  final VoidCallback? onProfileEdited;

  const MainDrawer({
    this.name,
    this.email,
    this.profileImageURL,
    this.onProfileEdited,
    required this.points
  });

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          color: Color(0xFFFEF7FF),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: SizeConfig.heightPercentage(2), top: SizeConfig.heightPercentage(3.5)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.heightPercentage(4.2),
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: SizeConfig.heightPercentage(3.8),
                        backgroundImage: (profileImageURL == null || profileImageURL!.isEmpty)
                            ? AssetImage('assets/profile_image.jpg') as ImageProvider
                            : NetworkImage(profileImageURL!),
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightPercentage(1)),
                    Text(
                      name ?? 'User Name',
                      style: TextStyle(color: Colors.white, fontSize: SizeConfig.heightPercentage(2), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email ?? 'Email',
                      style: TextStyle(color: Colors.white70, fontSize: SizeConfig.heightPercentage(1.5)),
                    ),
                    Text(
                      'Points: $points',
                      style: TextStyle(color: Colors.white70, fontSize: SizeConfig.heightPercentage(1.5)),
                    ),

                  ],
                ),
              ),
              SizedBox(height: SizeConfig.heightPercentage(1)),
              ListTile(
                leading: Icon(Icons.create, color: Colors.grey.shade600),
                title: Text('Edit Profile', style: TextStyle(color: Colors.grey.shade600)),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.pushNamed(context, 'profile_edit_page');
                  if (result == true && onProfileEdited != null) {
                    onProfileEdited!();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle_outline, color: Colors.grey.shade600),
                title: Text('Quests Completed', style: TextStyle(color: Colors.grey.shade600)),
                onTap: () {
                  Navigator.pushNamed(context, 'completed_quests_page');
                },
              ),
              ListTile(
                leading: Icon(Icons.card_giftcard, color: Colors.grey.shade600),
                title: Text('Bought Prizes', style: TextStyle(color: Colors.grey.shade600)),
                onTap: () {
                  Navigator.pushNamed(context, 'bought_prizes_page');
                },
              ),
              ListTile(
                leading: Icon(Icons.leaderboard, color: Colors.grey.shade600),
                title: Text('Leaderboard', style: TextStyle(color:Colors.grey.shade600)),
                onTap: () async {
                  Navigator.pushNamed(context, 'leaderboard_page');
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.grey.shade600),
                title: Text('Settings', style: TextStyle(color: Colors.grey.shade600)),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.pushNamed(context, 'settings_page');
                  if (result == true && onProfileEdited != null) {
                    onProfileEdited!();
                  }
                },
              ),
              Spacer(),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}