import 'package:flutter/material.dart';
import 'package:namer_app/services/firestoreAPI.dart';
import '../widgets/prize_card.dart';

class PrizeDetailPage extends StatefulWidget {
  final PrizeCard prize;

  const PrizeDetailPage({Key? key, required this.prize}) : super(key: key);

  @override
  _PrizeDetailPageState createState() => _PrizeDetailPageState();
}

class _PrizeDetailPageState extends State<PrizeDetailPage> {
  String email = '';
  String address = '150 Elgin Street\nOttawa, ON, Canada, K2P 1L4'; // Default address
  int currentPoints = 0;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final doc = await getUserDetails();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        email = data['email'] ?? '';
        currentPoints = data['points'] ?? 0;
      });

      emailController.text = email; // Preenche o email do usuário no controlador
      addressController.text = address; // Preenche o endereço no controlador
    }
  }

  void checkPointsAndProceed() async {
    if (currentPoints >= widget.prize.cost) {
      await addUserPrize(widget.prize.prizeID);
      await updateUserPoints(-widget.prize.cost);
      Navigator.pop(context, widget.prize);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insufficient points for this purchase.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "EcoQuest",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: email.isNotEmpty ? email : 'Enter your email', // Coloca o e-mail real ou um placeholder padrão
                    ),
                  ),
                  SizedBox(height: 8),

                  Text('Ship to', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: 'Country, City, Street, Number',
                    ),
                  ),
                  SizedBox(height: 8),

                  Text('Current Points Balance', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('$currentPoints points'),
                ],
              ),
            ),
            SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order summary', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(widget.prize.imagePath, width: 60, height: 60),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.prize.title, style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.prize.description),
                          ],
                        ),
                      ),
                      Text('${widget.prize.cost} pts'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal'),
                      Text('${widget.prize.cost} pts'),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Discount'),
                      Text('0 pts'),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${widget.prize.cost} pts', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: checkPointsAndProceed, // Chama a função para verificar os pontos
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text(
                        'Pay now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
