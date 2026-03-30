import 'package:flutter/material.dart';
import '../helper/size_config.dart';

class PrizeCard extends StatelessWidget {
  final String prizeID;
  final String imagePath;
  final String title;
  final int cost;
  final String description;

  const PrizeCard({
    super.key,
    required this.prizeID,
    required this.imagePath,
    required this.title,
    required this.cost,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.widthPercentage(3), vertical: SizeConfig.widthPercentage(2.4)),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.heightPercentage(1.3)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imagePath,
                width: SizeConfig.heightPercentage(13.1),
                height: SizeConfig.heightPercentage(13.1),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: SizeConfig.widthPercentage(3.7)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(
                      fontSize: SizeConfig.heightPercentage(2),
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(height: SizeConfig.heightPercentage(0.65)),
                  Text('$cost points',
                    style: TextStyle(
                      fontSize: SizeConfig.heightPercentage(1.6),
                      color: Colors.blue.shade800
                    )
                  ),
                  SizedBox(height: SizeConfig.heightPercentage(1.3)),
                  Row(
                    children: [
                      // Description bottom
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.info_outline),
                          iconSize: 28,
                          color: Colors.blue,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Description'),
                                content: Text(description),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Close'),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: SizeConfig.heightPercentage(1.3)),
                      // Purchase bottom
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.shopping_cart),
                          iconSize: 28,
                          color: Colors.white,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reward redeemed!'),
                                backgroundColor: Colors.blue,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
