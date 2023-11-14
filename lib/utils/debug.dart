import 'package:flutter/material.dart';

// Future<void> debug(BuildContext context, String title, String text) async {
//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Hello!'),
//         content: Text('You tapped the button!'),
//       );
//     },
//   );
// }

// shows a snackbar saying hello
void debug(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
