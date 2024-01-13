// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wallpaper_app/full_Screen.dart';

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

  Future<Stream<List<QuerySnapshot>>> getAllImagesDataStream() async {
    try {
      // Fetch documents from the collection_list
      QuerySnapshot collectionListSnapshot =
          await FirebaseFirestore.instance.collection('collection_list').get();

      // Extract category names from the documents in collection_list
      List<String> categoryNames = collectionListSnapshot.docs
          .map((doc) => doc['category'] as String?)
          .where((category) => category != null)
          .cast<String>()
          .toList();

      // Create streams for each category
      var streams = categoryNames
          .map((category) =>
              FirebaseFirestore.instance.collection(category).snapshots())
          .toList();

      // Combine the streams using CombineLatestStream from rxdart
      var combinedStream = CombineLatestStream.list(streams);

      return combinedStream;
    } catch (e) {
      print('Error in getAllImagesDataStream: $e');
      // Return an empty stream or handle the error appropriately
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchAndShuffleImages,
      child: isLoading
          ? const Center(
              child: Text('Loading...'),
            )
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: FutureBuilder<Stream<List<QuerySnapshot>>>(
                future: getAllImagesDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('Loading...'));
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  Stream<List<QuerySnapshot>> imagesDataStream =
                      snapshot.data ?? Stream.value([]);

                  List<QueryDocumentSnapshot> allDocuments = [];

                  return StreamBuilder<List<QuerySnapshot>>(
                    stream: imagesDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      for (var snapshotdata in snapshot.data!) {
                        for (var data in snapshotdata.docs) {
                          allDocuments.add(data);
                        }
                      }

                      allDocuments.shuffle();

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: allDocuments.length,
                        itemBuilder: (context, index) {
                          var imageUrl = allDocuments[index].get('link');
                          return GestureDetector(
                            child: GridTile(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FullScreen(
                                    urlLink: imageUrl,
                                    documentId: allDocuments[index].id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
