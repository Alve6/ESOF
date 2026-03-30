import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
        'Contact Us',
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
                'Please reach to us!\n\n'
                    'Feel free to send us an email if you have any doubt or question!\n\n'
                    'We usually take 3-5 business day to respond.'
            ),
            const SizedBox(height: 20),

            Text('Our email:'),

            Text('contactUs@ourapp.com',
              style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15 )
            ),

          ],
        )





      ),
    );
  }
}