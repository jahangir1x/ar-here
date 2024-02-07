import 'package:ar_here/screens/product_ar_screen.dart';
import 'package:ar_here/screens/upload_screen.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
  double? downloadProgress = 0;
  String downloadStatusText = '';
  bool isDownloading = false;
  bool isDownloaded = false;
  CancelToken cancelToken = CancelToken();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      floatingActionButton: (isDownloaded)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductArScreen(
                      modelPathFromAppDir: path.basename(widget.modelUrl),
                      title: widget.title,
                    ),
                  ),
                );
              },
              child: Icon(Icons.open_in_new),
            )
          : FloatingActionButton(
              onPressed: () async {
                if (isDownloading) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Cancel Download?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('No')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  cancelToken.cancel();
                                  setState(() {
                                    isDownloading = false;
                                    isDownloaded = false;
                                    downloadStatusText = '';
                                    cancelToken = CancelToken();
                                    downloadProgress = 0;
                                  });
                                },
                                child: Text('Yes')),
                          ],
                        );
                      });
                  return;
                }
                setState(() {
                  isDownloading = true;
                  isDownloaded = false;
                });
                Dio dio = Dio();
                String dir = (await getApplicationDocumentsDirectory()).path;
                String filepath = '${dir}/${path.basename(widget.modelUrl)}';
                dio.download(widget.modelUrl, '$filepath',
                    cancelToken: cancelToken, onReceiveProgress: (rec, total) {
                  setState(() {
                    downloadProgress = (rec / total);
                    var totalBytesInMb = total / 1000000;
                    var receivedBytesInMb = rec / 1000000;
                    downloadStatusText =
                        '${receivedBytesInMb.toStringAsFixed(2)}MB / ${totalBytesInMb.toStringAsFixed(2)}MB';
                  });
                }).then((value) {
                  setState(() {
                    isDownloading = false;
                    isDownloaded = true;
                  });
                });
              },
              child: Icon(Icons.download),
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
            Row(
              children: [
                Text(downloadStatusText),
                CircularProgressIndicator(
                  value: (isDownloading) ? downloadProgress : 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getDemoImagesPath(String imageUrl) {
    return RegExp(r"http.*/").firstMatch(imageUrl)!.group(0)!;
  }
}
