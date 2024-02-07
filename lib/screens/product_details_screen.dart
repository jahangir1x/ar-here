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
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _index = 0;

  FloatingActionButton renderGoToARButton(
      BuildContext context, String modelUrl) {
    return FloatingActionButton(
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
    );
  }

  FloatingActionButton renderDownloadButton(
      BuildContext context, String modelUrl) {
    return FloatingActionButton(
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
        dio.download(widget.modelUrl, '$filepath', cancelToken: cancelToken,
            onReceiveProgress: (rec, total) {
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
      child: (isDownloading) ? Icon(Icons.cancel) : Icon(Icons.download),
    );
  }

  Widget renderProductDetails(BuildContext context) {
    return SizedBox(
      height: 400, // Card height
      child: PageView.builder(
        itemCount: 4,
        controller: PageController(viewportFraction: 0.8),
        onPageChanged: (index) => setState(() => _index = index),
        itemBuilder: (context, index) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            padding: EdgeInsets.all(_index == index ? 0.0 : 15.0),
            child: Card(
              elevation: 20,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                  (index == 0)
                      ? widget.thumbnailUrl
                      : getDemoImagesPath(widget.modelUrl) + 'demo${index}.png',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget renderProductTextDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        '${widget.description}',
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.title}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // floatingActionButton: (isDownloaded)
      //     ? renderGoToARButton(context, widget.modelUrl)
      //     : renderDownloadButton(context, widget.modelUrl),
      body: Stack(
        children: [
          Column(
            children: [
              renderProductDetails(context),
              renderProductTextDetails(context),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: (isDownloaded)
                ? renderGoToARButton(context, widget.modelUrl)
                : renderDownloadButton(context, widget.modelUrl),
          ),
          Positioned(
            bottom: 80,
            right: 30,
            child: (isDownloading)
                ? CircularProgressIndicator(
                    value: (isDownloading) ? downloadProgress : 0,
                  )
                : Container(),
          )
        ],
      ),
    );
  }

// child: Column(
  //   children: [
  //     Text('${widget.description}'),
  //     Row(
  //       children: [
  //         Text(downloadStatusText),
  //         CircularProgressIndicator(
  //           value: (isDownloading) ? downloadProgress : 0,
  //         ),
  //       ],
  //     ),
  //   ],
  // ),

  String getDemoImagesPath(String imageUrl) {
    return RegExp(r"http.*/").firstMatch(imageUrl)!.group(0)!;
  }
}
