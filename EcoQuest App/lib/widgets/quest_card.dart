import 'package:flutter/material.dart';
import 'package:namer_app/pages/quest_page.dart';
import 'package:namer_app/services/firestoreAPI.dart';

import '../helper/size_config.dart';

enum QuestState {
  NO_STATE,
  ONGOING,
  COMPLETED
}

class QuestCard extends StatefulWidget {
  final String questID;
  final Map<String, dynamic> questData;

  const QuestCard({required this.questID, required this.questData,});

  @override
  State<QuestCard> createState() => _QuestCardState();
}

class _QuestCardState extends State<QuestCard> {
  bool expanded = false;
  QuestState state = QuestState.NO_STATE;

  @override
  void initState() {
    super.initState();
    setQuestState();
  }

  Future<void> setQuestState() async {
    if(await isOngoing(widget.questID)) {
      state = QuestState.ONGOING;
    } else if(await isCompleted(widget.questID)) {
      state = QuestState.COMPLETED;
    } else {
      state = QuestState.NO_STATE;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.all(SizeConfig.heightPercentage(1.3)),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.only(left: SizeConfig.heightPercentage(1.3), right: SizeConfig.heightPercentage(1.3), top: SizeConfig.heightPercentage(1.3), bottom: SizeConfig.heightPercentage(0.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: expanded ? SizeConfig.heightPercentage(19.7) : SizeConfig.heightPercentage(10.9),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: (widget.questData['imageURL'] == "" ? Image.asset('assets/trees_task.jpeg') : Image.network(widget.questData['imageURL'])),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.heightPercentage(0.87)),
                Text(
                  widget.questData['questName'],
                  style: TextStyle(
                    fontSize: SizeConfig.heightPercentage(2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.questData['points']} points',
                  style: TextStyle(
                    fontSize: SizeConfig.heightPercentage(1.5),
                    color: Colors.blue.shade700,
                  ),
                ),
                SizedBox(height: SizeConfig.heightPercentage(1.1)),
                AnimatedCrossFade(
                  firstChild: SizedBox(height: 0, width: double.infinity),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          widget.questData['smallDescription'],
                          style: TextStyle(fontSize: SizeConfig.heightPercentage(1.5)),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      SizedBox(height: SizeConfig.heightPercentage(1.1)),
                      Row(
                        children: [
                          if(state == QuestState.NO_STATE)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  addOngoingQuest(widget.questID);
                                  state = QuestState.ONGOING;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Task accepted!'),
                                      backgroundColor: Colors.blue,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: SizeConfig.heightPercentage(1.3)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.heightPercentage(1.75),
                                  ),
                                ),
                              ),
                            ),
                          if (state == QuestState.COMPLETED) FadedBox('Already Completed'),
                          if (state == QuestState.ONGOING) FadedBox('Already Accepted'),
                          SizedBox(width: SizeConfig.heightPercentage(1.3)),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final sstate = await Navigator.push(context, MaterialPageRoute(builder: (context) => QuestPage(questID: widget.questID, questData: widget.questData)));
                                if(sstate is QuestState) state = sstate;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: SizeConfig.heightPercentage(1.3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'More Info',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.heightPercentage(1.75),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.heightPercentage(1))
                    ],
                  ),
                  crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 300),
                  firstCurve: Curves.easeInOut,
                  secondCurve: Curves.easeInOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class FadedBox extends StatelessWidget {
  final String text;

  FadedBox(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.heightPercentage(1.3)),
          decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade100, width: 3)
          ),
          child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}