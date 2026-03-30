import 'package:flutter/material.dart';
import '../helper/size_config.dart';
import '../services/firestoreAPI.dart';
import '../widgets/bought_prize_card.dart';

class BoughtPrizesPage extends StatefulWidget {
  @override
  State<BoughtPrizesPage> createState() => _BoughtPrizesPageState();
}

class _BoughtPrizesPageState extends State<BoughtPrizesPage> {
  List<BoughtPrizeCard> cards = [];

  Future<void> loadBoughtPrizes() async {
    final doc = await getUserDetails();
    final data = doc.data() as Map<String, dynamic>;
    final List<dynamic> prizesBought = data['prizesBought'] ?? [];

    final prizeFutures = prizesBought.map((prizeID) async {
      final prize = await getPrizeDetails(prizeID);
      return BoughtPrizeCard(
        prizeID: prizeID,
        prizeData: prize.data() as Map<String, dynamic>,
      );
    }).toList();

    final prizeCards = await Future.wait(prizeFutures);

    setState(() {
      cards = prizeCards;
    });
  }

  @override
  void initState() {
    super.initState();
    loadBoughtPrizes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        title: Text(
          'Prizes Bought',
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
          separatorBuilder: (context, index) =>
              SizedBox(height: SizeConfig.heightPercentage(2)),
          itemBuilder: (context, index) {
            return cards[index];
          },
        ),
      ),
    );
  }
}
