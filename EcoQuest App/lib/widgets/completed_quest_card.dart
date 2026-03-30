import 'package:flutter/material.dart';
import '../helper/size_config.dart';

class CompletedQuestCard extends StatelessWidget {
  final String questID;
  final Map<String, dynamic> questData;

  const CompletedQuestCard({required this.questID, required this.questData,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: (questData['imageURL'] == ''
                ? Image.asset(
              'assets/trees_task.jpeg',
              height: SizeConfig.heightPercentage(18),
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Image.network(
              questData['imageURL'],
              height: SizeConfig.heightPercentage(18),
              width: double.infinity,
              fit: BoxFit.cover,
            )),
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.heightPercentage(2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(questData['questName'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.heightPercentage(2.2),
                  ),
                ),
                SizedBox(height: SizeConfig.heightPercentage(1)),
                Text(questData['smallDescription'],
                  style: TextStyle(
                    fontSize: SizeConfig.heightPercentage(1.7),
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: SizeConfig.heightPercentage(1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: SizeConfig.heightPercentage(2.5)),
                        SizedBox(width: SizeConfig.heightPercentage(1)),
                        Text('Completed',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.heightPercentage(1.7),
                          ),
                        ),
                      ],
                    ),
                    Text('+${questData['points']} pts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                        fontSize: SizeConfig.heightPercentage(1.8),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
