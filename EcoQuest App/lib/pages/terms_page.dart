import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
        'Terms and Agreements',
        style: TextStyle(

          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 30,
        ),
      ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                  'Welcome again to our app. By using EcoQuest, you are agreeing with the following Terms and Conditions.\n\n'
              ),
              const SizedBox(height: 50),

              Text(
                  '1. Always be respectful to everyone.\n\n'
              ),
              const SizedBox(height: 20),

              Text(
                  '2. You are responsible for everything you share inside and outside our app.\n\n'
              ),
              const SizedBox(height: 20),

              Text(
                  '3. As the EcoQuest Team, we have the right to suspend or even ban your account with justified cause.\n\n'
              ),
              const SizedBox(height: 20),

              Text(
                  '4. These Terms are governed by the laws of your state or even your country.\n\n'
              ),
              const SizedBox(height: 20),

              Text(
                  '5. Any doubts? Please send email to: contactUs@ourapp.com.\n\n'
              ),
              const SizedBox(height: 20),



              Text('A hug from our team,'),
              Text('ECOQUEST Team',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15 )
              ),

            ],
          )

      ),
    );
  }
}

