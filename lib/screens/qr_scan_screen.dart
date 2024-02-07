import 'package:flutter/material.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Scan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // a big demo qr code image
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Image.asset('Images/qrcode.png'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Scan QR Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
