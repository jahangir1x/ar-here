import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScrollableScreen extends StatefulWidget {
  const ScrollableScreen({Key? key}) : super(key: key);

  @override
  State<ScrollableScreen> createState() => _ScrollableScreenState();
}

class _ScrollableScreenState extends State<ScrollableScreen> {
  final serverUrl = 'http://127.0.0.1:8080/root/';
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrollable Screen'),
      ),
      body: ListView.builder(
        itemBuilder: (
          (context, index) {
            return ListTile(
              title: Text(
                index.toString(),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> fetchProducts() async {
    final productsUrl = '${serverUrl}lists-1.json';
    final uri = Uri.parse(productsUrl);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      setState(() {
        products = json;
      });
      print(response.body);
    } else {
      print('Failed to fetch products');
    }
  }
}
