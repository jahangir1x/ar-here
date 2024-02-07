import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Sign In'),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            // show google, facebook, and apple sign in buttons with icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      Icon(Icons.g_mobiledata),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      Icon(Icons.facebook),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: [
                      Icon(Icons.apple),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Create new account'),
            ),
          ],
        ),
      ),
    );
  }
}
