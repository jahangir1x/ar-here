import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String url;
  final String title;
  final String description;

  const ProductDetailsScreen(
      {required this.url, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Text('Product Details: $title $description $url'),
      ),
    );
  }
}
