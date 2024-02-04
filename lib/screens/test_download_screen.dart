import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFileScreen extends StatefulWidget {
  const DownloadFileScreen({Key? key}) : super(key: key);

  @override
  State<DownloadFileScreen> createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends State<DownloadFileScreen> {
  double? progress = 0;
  String status = '-_-';
  CancelToken cancelToken = CancelToken();
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: (isDownloading) ? progress : 0,
            ),
            Text(status),
            ElevatedButton(
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
                                    status = '-_-';
                                    cancelToken = CancelToken();
                                    progress = 0;
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
                });
                Dio dio = Dio();
                String dir = (await getApplicationDocumentsDirectory()).path;
                dio.download(
                    'https://media.githubusercontent.com/media/jahangir1x/gltf-models/main/models/viking_drakkar_long_boat_low-poly/viking_drakkar_long_boat_low-poly.glb',
                    '${dir}/boat.glb',
                    cancelToken: cancelToken, onReceiveProgress: (rec, total) {
                  setState(() {
                    progress = (rec / total);
                    var totalBytesInMb = total / 1000000;
                    var receivedBytesInMb = rec / 1000000;
                    status =
                        '${receivedBytesInMb.toStringAsFixed(2)}MB / ${totalBytesInMb.toStringAsFixed(2)}MB';
                  });
                }).then((value) {
                  setState(() {
                    status = 'Downloaded';
                  });
                });
              },
              child: Text('Download'),
            )
          ],
        ),
      ),
    );
  }
}
