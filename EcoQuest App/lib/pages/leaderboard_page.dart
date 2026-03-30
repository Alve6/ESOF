import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helper/size_config.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> topUsers = [];

  Future<void> loadTopUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('Users').orderBy('totalPoints', descending: true).limit(10).get();

    setState(() {
      topUsers = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] ?? '',
          'email': data['email'] ?? '',
          'totalPoints': data['totalPoints'] ?? 0,
          'profileImageURL': data['profileImageURL'] ?? '',
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadTopUsers();
  }

  Widget buildCrown(int index) {
    switch (index) {
      case 0:
        return Icon(Icons.emoji_events, color: Colors.amber, size: 32);
      case 1:
        return Icon(Icons.emoji_events, color: Colors.grey, size: 28);
      case 2:
        return Icon(Icons.emoji_events, color: Colors.brown, size: 24);
      default:
        return SizedBox();
    }
  }

  Color getDecorationColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber.shade100;
      case 1:
        return Colors.grey.shade200;
      case 2:
        return Colors.brown.shade100;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        title: Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.heightPercentage(3.2),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.heightPercentage(2)),
        child: ListView.separated(
          itemCount: topUsers.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: SizeConfig.heightPercentage(2)),
          itemBuilder: (context, index) {
            final user = topUsers[index];
            return Container(
              decoration: BoxDecoration(
                color: getDecorationColor(index),
                borderRadius: BorderRadius.circular(12),
                border: index < 3
                    ? Border.all(color: Colors.green.shade700, width: 2)
                    : Border.all(color: Colors.grey.shade300),
                boxShadow: index < 3
                    ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10)]
                    : [],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user['profileImageURL'].isNotEmpty
                      ? NetworkImage(user['profileImageURL'])
                      : null,
                  backgroundColor: Colors.green.shade400,
                  radius: 25,
                  child: user['profileImageURL'].isEmpty
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                title: Row(
                  children: [
                    Text(
                      user['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 4),
                    buildCrown(index),
                  ],
                ),
                subtitle: Text(user['email']),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.orange,),
                    Text(
                      '${user['totalPoints']} pts',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
