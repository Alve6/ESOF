import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
      'FeedBack',
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
                      'Feel free to give your feedback so that we can improve!\n\n'
              ),
              const SizedBox(height: 20),

              Text('Our forms:'),

              Text('feedBack@formsLink.com',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15 )
              ),

            ],
          )





      ),
    );
  }
}