import 'package:flutter/material.dart';
import '../helper/size_config.dart';
import '../services/firestoreAPI.dart';
import '../widgets/completed_quest_card.dart';

class CompletedQuestsPage extends StatefulWidget {
  @override
  State<CompletedQuestsPage> createState() => _CompletedQuestsPageState();
}

class _CompletedQuestsPageState extends State<CompletedQuestsPage> {
  List<CompletedQuestCard> cards = [];

  Future<void> loadCompletedQuests() async {
    final doc = await getUserDetails();
    final data = doc.data() as Map<String, dynamic>;
    final List<dynamic> completedQuestIDs = data['completedQuests'] ?? [];

    final questFutures = completedQuestIDs.map((questID) async {
      final quest = await getQuestDetails(questID);
      return CompletedQuestCard(
        questID: questID,
        questData: quest.data() as Map<String, dynamic>,
      );
    }).toList();

    final questCards = await Future.wait(questFutures);

    setState(() {
      cards = questCards;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCompletedQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        title: Text('Completed Quests',
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
          itemCount: cards.length,
          separatorBuilder: (context, index) => SizedBox(height: SizeConfig.heightPercentage(2)),
          itemBuilder: (context, index) {
            return cards[index];
          },
        ),
      ),
    );
  }
}
