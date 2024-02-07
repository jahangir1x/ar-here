import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ar_here/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  String searchString = '';
  List products = [];
  int page = 1;
  bool isLoadingMoreData = false;

  @override
  void initState() {
    super.initState();
    // Navigator.push(context, MaterialPageRoute(builder: (builder) {
    //   return ProductDetailsScreen(
    //     thumbnailUrl:
    //         'https://media.githubusercontent.com/media/jahangir1x/gltf-models/main/models/viking_drakkar_long_boat_low-poly/pic.png',
    //     modelUrl:
    //         'https://media.githubusercontent.com/media/jahangir1x/gltf-models/main/models/viking_drakkar_long_boat_low-poly/viking_drakkar_long_boat_low-poly.glb',
    //     title: 'Viking Drakkar Long Boat Low-Poly',
    //     description: 'Viking Drakkar Long Boat Low-Poly',
    //   );
    // }));
    scrollController.addListener(() async {
      if (isLoadingMoreData) {
        return;
      }
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        setState(() {
          isLoadingMoreData = true;
        });
        await fetchProducts();
        setState(() {
          isLoadingMoreData = false;
        });
      }
    });
    fetchProducts();
  }

  Widget drawSearchBox() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 16, bottom: 0),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
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
                onChanged: (value) {
                  searchString = value;
                  searchAndFilterProducts();
                },
                decoration: InputDecoration(
                  hintText: 'Search for ...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsetsDirectional.only(
                    start: 16,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                searchAndFilterProducts();
              },
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Theme.of(context).colorScheme.background,
                      Colors.transparent,
                      Colors.transparent,
                      Theme.of(context).colorScheme.background,
                    ],
                    stops: [0.0, 0.02, 0.96, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: (products.length == 0)
                    ? Center(
                        // Show internet connection error
                        child: Text('Network error 😢'),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 16,
                          crossAxisCount: 2,
                        ),
                        controller: scrollController,
                        itemCount: isLoadingMoreData
                            ? products.length + 1
                            : products.length,
                        itemBuilder: (context, index) {
                          if (index < products.length) {
                            final name = products[index]['name'];
                            final description = products[index]['description'];
                            final modelUrl = products[index]['model_path'];
                            final imageUrl = products[index]['image_path'];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 0, bottom: 0),
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
                                        tag: imageUrl,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.cover,
                                            height: 140,
                                            width: double.infinity,
                                            placeholder: ((context, url) =>
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '$name',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '$description',
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 11,
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
                                    print('tapped $name');
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return ProductDetailsScreen(
                                        thumbnailUrl: imageUrl,
                                        modelUrl: modelUrl,
                                        title: name,
                                        description: description,
                                      );
                                    }));
                                  },
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
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
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchProducts() async {
    final productsUrl =
        'https://raw.githubusercontent.com/jahangir1x/gltf-models/main/lists-${page}.json';
    print(productsUrl);
    final uri = Uri.parse(productsUrl);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        setState(() {
          products += json;
        });
      }
    } catch (e) {}
    print(products.length);
  }

  Future<void> searchAndFilterProducts() async {
    final allProductsUrl =
        'https://raw.githubusercontent.com/jahangir1x/gltf-models/main/lists.json';
    final uri = Uri.parse(allProductsUrl);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        final filteredProducts = json.where((element) {
          return (element['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchString.toLowerCase()) ||
              element['description']
                  .toString()
                  .toLowerCase()
                  .contains(searchString.toLowerCase()));
        }).toList();
        setState(() {
          products = filteredProducts;
        });
      }
    } catch (e) {}
  }
}
