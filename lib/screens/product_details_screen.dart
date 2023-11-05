import 'package:demo_space/screens/product_ar_screen.dart';
import 'package:demo_space/screens/upload_screen.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String thumbnailUrl;
  final String modelUrl;
  final String title;
  final String description;

  const ProductDetailsScreen(
      {required this.thumbnailUrl,
      required this.modelUrl,
      required this.title,
      required this.description});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('${widget.description}'),
                Padding(padding: const EdgeInsets.all(8.0)),
                Text('${widget.thumbnailUrl}'),
                Padding(padding: const EdgeInsets.all(8.0)),
                Text('${widget.modelUrl}'),
                Padding(padding: const EdgeInsets.all(8.0)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ProductArScreen(
                          modelUrl: widget.modelUrl,
                          title: widget.title,
                        ),
                      ),
                    );
                  },
                  child: Text("View in your place"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
