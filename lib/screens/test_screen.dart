import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Test Title'),
      ),
      body: Container(
        child: Stack(
          children: [
            Placeholder(
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
