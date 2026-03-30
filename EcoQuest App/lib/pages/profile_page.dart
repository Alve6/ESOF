import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:namer_app/services/healthAPI.dart';

import '../services/firestoreAPI.dart';
import '../widgets/drawer.dart';
import '../helper/size_config.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "", name = "", email = "", birthdate = "", phone = "", profileImageURL = "";
  int totalPoints = 0, points = 0, ongoingQuestsSize = 0, completedQuestsSize = 0, distanceWalked = 0;
  bool available = false;
  final health = Health();


  void logout(){
    FirebaseAuth.instance.signOut();
  }

  List<String> quests = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final doc = await getUserDetails();
    final data = doc.data() as Map<String, dynamic>;

    final List<String> completedQuestNames = await Future.wait(
      (data['completedQuests'] as List<dynamic>).map((questID) async {
        final quest = await getQuestDetails(questID);
        final questData = quest.data() as Map<String, dynamic>;
        return questData['questName'] as String;
      }),
    );

    int steps = 0;
    available = await health.isHealthConnectAvailable();
    if (available) {
      steps = await getAllSteps();
    }

    setState(() {
      username = data['username'];
      name = data['name'];
      email = data['email'];
      birthdate = data['birthdate'];
      phone = data['phone'];
      profileImageURL = data["profileImageURL"];
      points = data["points"];
      totalPoints = data['totalPoints'] ?? 0;
      ongoingQuestsSize = data['ongoingQuests']?.length ?? 0;
      completedQuestsSize = data['completedQuests']?.length ?? 0;
      distanceWalked = steps;
      quests = completedQuestNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: SizeConfig.heightPercentage(4),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
      ),
      drawer: MainDrawer(
        name: name,
        email: email,
        profileImageURL: profileImageURL,
        onProfileEdited: () {
          loadUserData();
        },
        points: points,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 2.0,
                colors: [
                  Color(0xFFBBDEFB),
                  Color(0xFF64B5F6),
                  Color(0xFF2196F3),
                  Color(0xFFBBDEFB),
                  Color(0xFFFEF7FF),
                ],
                stops: [0.0, 0.3, 0.6, 0.95, 1.0],
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: SizeConfig.heightPercentage(4.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Center(
                        child: CircleAvatar(
                          radius: SizeConfig.heightPercentage(6.5),
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: SizeConfig.heightPercentage(6),
                            backgroundImage: (profileImageURL == "" ? AssetImage('assets/profile_image.jpg') : NetworkImage(profileImageURL)),
                          ),
                        ),
                      ),
                  ),
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.only(right: SizeConfig.widthPercentage(4)),
                      elevation: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Profile',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: SizeConfig.heightPercentage(1)),
                            Text("Name", style: TextStyle(fontWeight: FontWeight.w500, fontSize: SizeConfig.heightPercentage(1.7))),
                            Text(name, style: TextStyle(fontWeight: FontWeight.w300)),
                            SizedBox(height: SizeConfig.heightPercentage(2)),
                            Text("Email", style: TextStyle(fontWeight: FontWeight.w500, fontSize: SizeConfig.heightPercentage(1.7))),
                            Text(email, style: TextStyle(fontWeight: FontWeight.w300)),
                            SizedBox(height: SizeConfig.heightPercentage(2)),
                            Text("Phone", style: TextStyle(fontWeight: FontWeight.w500, fontSize: SizeConfig.heightPercentage(1.7))),
                            Text(phone, style: TextStyle(fontWeight: FontWeight.w300)),
                            SizedBox(height: SizeConfig.heightPercentage(2)),
                            Text("Birthdate", style: TextStyle(fontWeight: FontWeight.w500, fontSize: SizeConfig.heightPercentage(1.7))),
                            Text(birthdate, style: TextStyle(fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.heightPercentage(3)),
              Text("Quests Completed", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade100)),
              SizedBox(height: SizeConfig.heightPercentage(1)),
              Container(
                height: SizeConfig.heightPercentage(10),
                child: PageView.builder(
                  itemCount: (quests.length / 3).ceil(),
                  controller: PageController(viewportFraction: 1),
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * 3;
                    final endIndex = (startIndex + 3).clamp(0, quests.length);
                    final pageItems = quests.sublist(startIndex, endIndex);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: pageItems.map((item) {
                        return Container(
                          width: SizeConfig.widthPercentage(28),
                          height: SizeConfig.heightPercentage(10),
                          margin: EdgeInsets.symmetric(horizontal: SizeConfig.widthPercentage(1)),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blue.shade800),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              SizedBox(height: SizeConfig.heightPercentage(5)),
              Card(
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.widthPercentage(4)),
                elevation: 4,
                color: Colors.blue.shade700,
                child: Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.heightPercentage(2), top: SizeConfig.heightPercentage(1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(totalPoints.toString(), style: TextStyle(color: Colors.white, fontSize: SizeConfig.heightPercentage(5.5))),
                          Text("Total Points", style: TextStyle(color: Colors.white)),
                          SizedBox(height: SizeConfig.heightPercentage(5)),
                          Text(completedQuestsSize.toString(), style: TextStyle(color: Colors.white, fontSize: SizeConfig.heightPercentage(5.5))),
                          Text("Quests Completed", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(ongoingQuestsSize.toString(), style: TextStyle(color: Colors.white, fontSize: SizeConfig.heightPercentage(5.5))),
                          Text("Ongoing Quests", style: TextStyle(color: Colors.white)),
                          SizedBox(height: SizeConfig.heightPercentage(5)),
                          if(available) Text(distanceWalked.toString(), style: TextStyle(color: Colors.white, fontSize: SizeConfig.heightPercentage(5.5))),
                          if(!available) SizedBox(height: SizeConfig.heightPercentage(2.4)),
                          if(!available)
                            InkWell(
                              onTap: () async {
                                await health.installHealthConnect();
                                bool available = await health.isHealthConnectAvailable();
                                if (available) {
                                  setState(() {
                                    available = true;
                                  });
                                }
                              },
                              child: Text("Google Health\nnot installed", style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
                            ),
                          if(!available) SizedBox(height: SizeConfig.heightPercentage(1)),
                          Text("Kilometers walked", style: TextStyle(color: Colors.white)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}