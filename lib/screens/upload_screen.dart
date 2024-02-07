import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Model Name',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Model Description',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Upload GLB Model File'),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.image),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.image),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.image),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
