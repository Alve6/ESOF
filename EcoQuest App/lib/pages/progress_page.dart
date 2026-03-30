import 'package:flutter/material.dart';
import 'package:namer_app/pages/quest_page.dart';
import 'package:namer_app/services/firestoreAPI.dart';
import 'package:namer_app/widgets/in_progress_card.dart';

import '../helper/size_config.dart';

class ProgressPage extends StatefulWidget {
  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<InProgressCard> cards = [];

  Future<void> loadOngoingQuests() async {
    final doc = await getUserDetails();
    final data = doc.data() as Map<String, dynamic>;
    final List<dynamic> ongoingQuestIDs = data['ongoingQuests'] ?? [];

    final questFutures = ongoingQuestIDs.map((questID) async {
      final quest = await getQuestDetails(questID);
      return InProgressCard(
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
    loadOngoingQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'In Progress',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.heightPercentage(4.4),
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.widthPercentage(3)),
        child: GridView.builder(
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: SizeConfig.heightPercentage(0.5),
            crossAxisSpacing: SizeConfig.widthPercentage(1.5),
            childAspectRatio: SizeConfig.widthPercentage(40) / SizeConfig.heightPercentage(19.5)
          ),
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestPage(
                      questID: cards[index].questID,
                      questData: cards[index].questData,
                    ),
                  ),
                );
                if (mounted) {
                  setState(() {
                    cards = [];
                  });
                  await loadOngoingQuests();
                }
              },
              child: cards[index],
            );
          },
        ),
      ),
    );
  }
}

