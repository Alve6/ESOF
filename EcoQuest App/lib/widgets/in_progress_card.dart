import 'package:flutter/material.dart';

import '../helper/size_config.dart';

class InProgressCard extends StatefulWidget {
  final String questID;
  final Map<String, dynamic> questData;

  InProgressCard({required this.questID, required this.questData,});

  @override
  State<InProgressCard> createState() => _InProgressCardState();
}

class _InProgressCardState extends State<InProgressCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.all(SizeConfig.heightPercentage(1.3)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.only(left: SizeConfig.heightPercentage(1.3), right: SizeConfig.heightPercentage(1.3), top: SizeConfig.heightPercentage(1.3), bottom: SizeConfig.heightPercentage(0.5)),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.heightPercentage(10.9),
              width: SizeConfig.widthPercentage(100),
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
            Text(widget.questData['questName'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
}
