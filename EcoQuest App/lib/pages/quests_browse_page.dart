import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/services/firestoreAPI.dart';
import '../helper/size_config.dart';
import '../widgets/quest_card.dart';

class QuestsBrowsePage extends StatefulWidget {
  @override
  _QuestsBrowsePageState createState() => _QuestsBrowsePageState();
}

class _QuestsBrowsePageState extends State<QuestsBrowsePage> {
  TextEditingController _searchController = TextEditingController();
  List<QuestCard> allQuests = [];

  @override
  void initState() {
    super.initState();
    loadQuests();
  }

  Future<void> loadQuests() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await getAllQuests();
    allQuests = snapshot.docs.map((doc) => QuestCard(
      questID: doc.id,
      questData: doc.data(),
    )).toList();
    setState(() {});
  }

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    List<QuestCard> filteredQuests = allQuests.where((quest) {
      return quest.questData['questName'].toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quests',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.heightPercentage(4.4),
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.heightPercentage(0.87)),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredQuests,
            ),
          ),
        ],
      ),
    );
  }
}