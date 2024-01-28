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
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  makeRoundButton('+', () {}),
                  Padding(padding: const EdgeInsets.all(4.0)),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 0, bottom: 0),
                    color: Colors.white,
                    child: Text(
                      '100%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(4.0)),
                  makeRoundButton('-', () {}),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  makeRoundButton(String buttonText, VoidCallback callback) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
      ),
      onPressed: callback,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
