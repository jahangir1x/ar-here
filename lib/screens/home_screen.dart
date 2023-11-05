import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_space/screens/product_details_screen.dart';
import 'package:demo_space/screens/product_ar_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 0),
        child: Column(
          children: [
            drawSearchBox(),
            Expanded(
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.white,
                    ],
                    stops: [0.0, 0.02, 0.96, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 16,
                    crossAxisCount: 2,
                  ),
                  children: [
                    makeBoxButton(
                      context,
                      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/screenshot/screenshot.png',
                      'https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb',
                      'Duck',
                      'Some company',
                    ),
                    makeBoxButton(
                      context,
                      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Fox/screenshot/screenshot.jpg',
                      'https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Fox/glTF-Binary/Fox.glb',
                      'Title 2',
                      'Description 2',
                    ),
                    makeBoxButton(
                      context,
                      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/GlamVelvetSofa/screenshot/screenshot.jpg',
                      'https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/GlamVelvetSofa/glTF-Binary/GlamVelvetSofa.glb',
                      'Title 3',
                      'Description 3',
                    ),
                    makeBoxButton(
                      context,
                      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Lantern/screenshot/screenshot.jpg',
                      'https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Lantern/glTF-Binary/Lantern.glb',
                      'Title 4',
                      'Description 4',
                    ),
                    makeBoxButton(
                      context,
                      'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/BoomBox/screenshot/screenshot.jpg',
                      'https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/BoomBox/glTF-Binary/BoomBox.glb',
                      'Title 4',
                      'Description 4',
                    ),
                    makeBoxButton(
                      context,
                      'https://picsum.photos/250?image=4',
                      '',
                      'Title 4',
                      'Description 4',
                    ),
                    makeBoxButton(
                      context,
                      'https://picsum.photos/250?image=4',
                      '',
                      'Title 4',
                      'Description 4',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawSearchBox() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 16, bottom: 0),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsetsDirectional.only(
                    start: 16,
                  ),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  makeBoxButton(BuildContext context, String thumbnailUrl, String modelUrl,
      String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
      child: Container(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Hero(
                tag: thumbnailUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: thumbnailUrl,
                    fit: BoxFit.cover,
                    height: 170,
                    width: double.infinity,
                    placeholder: ((context, url) => Center(
                          child: CircularProgressIndicator(),
                        )),
                  ),
                  // child: Image.network(
                  //   url,
                  //   fit: BoxFit.cover,
                  //   height: 170,
                  //   width: double.infinity,
                  // ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            print('tapped ' + title);
            Navigator.push(context, MaterialPageRoute(builder: (builder) {
              return ProductDetailsScreen(
                thumbnailUrl: thumbnailUrl,
                modelUrl: modelUrl,
                title: title,
                description: description,
              );
            }));
          },
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
