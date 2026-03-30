import 'package:flutter/material.dart';

import '../helper/size_config.dart';
import '../services/firestoreAPI.dart';
import '../widgets/quest_card.dart';

class QuestPage extends StatefulWidget {
  final String questID;
  final Map<String, dynamic> questData;

  const QuestPage({required this.questID, required this.questData});

  @override
  State<QuestPage> createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  QuestState state = QuestState.NO_STATE;

  @override
  void initState() {
    super.initState();
    setQuestState();
  }

  Future<void> setQuestState() async {
    if (await isOngoing(widget.questID)) {
      setState(() {
        state = QuestState.ONGOING;
      });
    } else if (await isCompleted(widget.questID)) {
      setState(() {
        state = QuestState.COMPLETED;
      });
    } else {
      setState(() {
        state = QuestState.NO_STATE;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            constraints: BoxConstraints(
              maxHeight: SizeConfig.heightPercentage(40),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.questData['imageURL'] == ""
                    ? AssetImage('assets/trees_task.jpeg')
                    : NetworkImage(widget.questData['imageURL']),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: SizeConfig.heightPercentage(37)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthPercentage(5)),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFFEF7FF),
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: SizeConfig.heightPercentage(2)),
                        Text(
                          widget.questData['questName'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          '${widget.questData['points']} points',
                          style: TextStyle(
                            color: Colors.greenAccent.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: SizeConfig.heightPercentage(4)),
                        Text(
                          widget.questData['description'],
                          style: TextStyle(color: Color(0xFFad98c6)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  if (state == QuestState.NO_STATE)
                    ElevatedButton(
                      onPressed: () {
                        addOngoingQuest(widget.questID);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Task accepted!'),
                            backgroundColor: Colors.blue,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context, QuestState.ONGOING);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(SizeConfig.widthPercentage(90), 0),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Accept',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  if (state == QuestState.COMPLETED) FadedBox('Already Completed'),
                  if (state == QuestState.ONGOING)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthPercentage(5)),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await completeQuest(widget.questID);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Quest completed!'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pop(context, QuestState.COMPLETED);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Complete Quest',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(width: SizeConfig.widthPercentage(3)),
                          IconButton(
                            onPressed: () async {
                              bool? confirm = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Cancel Quest'),
                                    content: Text('Are you sure you want to cancel this quest?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                await removeOngoingQuest(widget.questID);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Quest cancelled successfully.'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(Icons.close, color: Colors.white),
                            iconSize: SizeConfig.heightPercentage(3.5),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: SizeConfig.heightPercentage(4)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FadedBox extends StatelessWidget {
  final String text;

  FadedBox(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthPercentage(90),
      padding: EdgeInsets.symmetric(vertical: SizeConfig.heightPercentage(1.3)),
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100, width: 3),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: SizeConfig.heightPercentage(1.55),
        ),
      ),
    );
  }
}
