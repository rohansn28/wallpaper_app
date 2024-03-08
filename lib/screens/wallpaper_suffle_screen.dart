// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wallpaper_app/full_Screen.dart';
import 'dart:math';

class WallpaprSuffleScreen extends StatefulWidget {
  const WallpaprSuffleScreen({super.key});

  @override
  State<WallpaprSuffleScreen> createState() => _WallpaprSuffleScreenState();
}

class _WallpaprSuffleScreenState extends State<WallpaprSuffleScreen> {
  late List<DocumentSnapshot> documents;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch initial set of documents
    fetchAndShuffleImages();
    // generateRandomNumberList();
  }

  Future<List<String>> collectionList() async {
    List<String> collectionNames = [];
    await FirebaseFirestore.instance
        .collection('collection_list')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        collectionNames.add(docSnapshot.data()['category']);
      }
    });
    return collectionNames;
  }

  Future<void> fetchAndShuffleImages() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<String> collectionNames = await collectionList();

      var streams = collectionNames
          .map((collection) =>
              FirebaseFirestore.instance.collection(collection).snapshots())
          .toList();
      streams.shuffle();
    } catch (e) {
      print('Error fetching or shuffling images: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<String> generateFormattedList(List<String> list1, List<int> list2) {
    if (list1.isEmpty || list2.isEmpty) {
      throw ArgumentError('Lists cannot be empty');
    }

    final formattedList = <String>[];
    final uniqueSet = <String>{};

    for (final item1 in list1) {
      for (final item2 in list2) {
        final combination = '$item1/$item1$item2';
        if (!uniqueSet.contains(combination)) {
          formattedList.add(combination);
          uniqueSet.add(combination);
        }
      }
    }

    formattedList.shuffle();

    return formattedList;
  }

  // Future<Stream<List<QuerySnapshot>>> getAllImagesDataStream() async {
  //   try {
  //     // Fetch documents from the collection_list
  //     QuerySnapshot collectionListSnapshot =
  //         await FirebaseFirestore.instance.collection('collection_list').get();

  //     // Extract category names from the documents in collection_list
  //     List<String> categoryNames = collectionListSnapshot.docs
  //         .map((doc) => doc['category'] as String?)
  //         .where((category) => category != null)
  //         .cast<String>()
  //         .toList();

  //     // Create streams for each category
  //     var streams = categoryNames
  //         .map((category) =>
  //             FirebaseFirestore.instance.collection(category).snapshots())
  //         .toList();

  //     // Combine the streams using CombineLatestStream from rxdart
  //     var combinedStream = CombineLatestStream.list(streams);

  //     return combinedStream;
  //   } catch (e) {
  //     print('Error in getAllImagesDataStream: $e');
  //     // Return an empty stream or handle the error appropriately
  //     return Stream.value([]);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    List<String> catList = ['anime', 'car', 'nature', 'image', 'people'];
    var finList =
        generateFormattedList(catList, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: generateFormattedList(
              catList, List.generate(10, (index) => index + 1)).length,
          itemBuilder: (BuildContext context, int index) {
            var url = 'https://unfoldedtechnews.website/${finList[index]}.jpg';
            print(url);
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FullScreen(
                        urlLink: url,
                      ),
                    ),
                  );
                },
                child: GridTile(
                  child: CachedNetworkImage(
                    width: 200,
                    height: 200,
                    imageUrl: url,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            // colorFilter: ColorFilter.mode(
                            //   Colors.black54.withOpacity(0.2),
                            //   BlendMode.colorBurn,
                            // ),
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) => const Text('Loading...'),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
