import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
        'Privacy and Policy',
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
            children: [
              const SizedBox(height: 50),
              Text(
                  'Welcome again to our app. By using EcoQuest, your privacy is protected.\n\n'
              ),
              const SizedBox(height: 50),

              Text(
                  '1. The only information we get from the users, is the one provided bye them and also the goals preferences\n\n'
              ),
              const SizedBox(height: 20),

              Text(
                  '2. We do not use or share your personal data with anyone.\n\n'
              ),
              const SizedBox(height: 20),

              Text(
                  '3. We, with the information the user give us, we try to provide a better experience on our app\n\n'
              ),
              const SizedBox(height: 20),

              Text(
                  '4. As a user, at any point, you have the right to modify your personal data\n\n'
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