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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductArScreen(
                modelUrl: widget.modelUrl,
                title: widget.title,
              ),
            ),
          );
        },
        child: Icon(Icons.open_in_new),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('${widget.description}'),
            Image(image: NetworkImage('${widget.thumbnailUrl}')),
            Image(
                image: NetworkImage(
                    '${getDemoImagesPath(widget.modelUrl)}demo1.png')),
            Image(
                image: NetworkImage(
                    '${getDemoImagesPath(widget.modelUrl)}demo2.png')),
            Image(
                image: NetworkImage(
                    '${getDemoImagesPath(widget.modelUrl)}demo3.png')),
          ],
        ),
      ),
    );
  }

  String getDemoImagesPath(String imageUrl) {
    return RegExp(r"http.*/").firstMatch(imageUrl)!.group(0)!;
  }
}
