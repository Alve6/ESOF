import 'package:flutter/material.dart';
import 'privacy_policy_page.dart';
import 'terms_page.dart';
import 'contact_page.dart';
import 'feedback_page.dart';


class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {

  void _openPrivacyPolicy() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyPolicyPage()));
  }

  void _openTerms() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => TermsPage()));
  }

  void _contactUs() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ContactPage()));
  }

  void _openFeedback() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => FeedbackPage()));
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(


        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          title: const Text(
            'Settings',
            style: TextStyle(

              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 35,
            ),
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildSettingsTile(Icons.lock, 'Privacy Policy', _openPrivacyPolicy),
            const SizedBox(height: 20),
            buildSettingsTile(Icons.description, 'Terms And Conditions', _openTerms),
            const SizedBox(height: 20),
            buildSettingsTile(Icons.email_outlined, 'Contact Us', _contactUs),
            const SizedBox(height: 20),
            buildSettingsTile(Icons.chat_bubble_outline, 'Feedback', _openFeedback),

          ],
        ),
      );

  }

  Widget buildSettingsTile(IconData icon, String title, VoidCallback action) {
    return ListTile(
      leading: Icon(icon, color: Colors.black.withOpacity(0.7)),
      title: Text(title),
      onTap: action,
    );
  }
}


