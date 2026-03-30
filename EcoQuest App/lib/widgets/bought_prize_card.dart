import 'package:flutter/material.dart';

class BoughtPrizeCard extends StatelessWidget {
  final String prizeID;
  final Map<String, dynamic> prizeData;

  const BoughtPrizeCard({
    required this.prizeID,
    required this.prizeData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.card_giftcard, size: 40, color: Colors.green),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prizeData['prizeName'] ?? 'Unknown Prize',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    prizeData['description'] ?? '',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
