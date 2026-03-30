import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/services/firestoreAPI.dart';
import '../helper/size_config.dart';
import '../widgets/prize_card.dart';
import 'prize_detail_page.dart';

class PrizesPage extends StatefulWidget {
  @override
  _PrizesPageState createState() => _PrizesPageState();
}

class _PrizesPageState extends State<PrizesPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  PrizeCard? selectedPrize;

  List<PrizeCard> allPrizes = [];

  Future<void> loadPrizes() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await getAllPrizes();
    allPrizes = snapshot.docs.map((doc) => PrizeCard(
      prizeID: doc.id,
      imagePath: doc.data()['imageURL'],
      title: doc.data()['prizeName'],
      cost: doc.data()['points'],
      description: doc.data()['description'],
    )).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadPrizes();
  }

  void _openPrizeDetails(PrizeCard prize) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrizeDetailPage(prize: prize),
      ),
    );

    if (result != null && result is PrizeCard) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchased ${result.title}!'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPrizes = allPrizes.where((prize) {
      return prize.title.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prizes',
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
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPrizes.length,
              itemBuilder: (context, index) {
                final prize = filteredPrizes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPrize = prize;
                    });

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        contentPadding: EdgeInsets.all(20),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return RadialGradient(
                                  center: Alignment.center,
                                  radius: 1.2,
                                  colors: [
                                    Colors.black,
                                    Colors.black.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                  stops: [0.3, 0.6, 1.0],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  prize.imagePath,
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              prize.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Text(
                              prize.description,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _openPrizeDetails(prize);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: Size(160, 50),
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              child: Text('Buy Now', style: TextStyle(color: Colors.white))
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthPercentage(3),
                      vertical: SizeConfig.heightPercentage(1),
                    ),
                    padding: EdgeInsets.all(SizeConfig.heightPercentage(1)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            prize.imagePath,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          prize.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
