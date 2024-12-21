import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Info'), actions: [
        IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          icon: Icon(Icons.logout),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Name: John Doe'),
            Text('Email: ${user?.email ?? 'No email available'}'),
            SizedBox(height: 20),
            Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Dummy Setting 1'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle setting 1 tap
              },
            ),
            ListTile(
              title: Text('Dummy Setting 2'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle setting 2 tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
