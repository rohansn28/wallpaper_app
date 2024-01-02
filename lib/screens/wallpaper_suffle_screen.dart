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

      // var querySnapshot =
      //     await FirebaseFirestore.instance.collection('images').get();
      var streams = collectionNames
          .map((collection) =>
              FirebaseFirestore.instance.collection(collection).snapshots())
          .toList();
      streams.shuffle();
      // documents = querySnapshot.docs.toList();
      // documents.shuffle();
    } catch (e) {
      print('Error fetching or shuffling images: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Stream<List<QuerySnapshot>> getAllImagesData() {
    // print(collectionList());
    var collectionNames = ['nature', 'cars', 'anime', 'people', 'images'];

    var streams = collectionNames
        .map((collection) =>
            FirebaseFirestore.instance.collection(collection).snapshots())
        .toList();

    // Combine the streams using CombineLatestStream from rxdart
    var combinedStream = CombineLatestStream.list(streams);

    return combinedStream;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchAndShuffleImages,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<List<QuerySnapshot>>(
              stream: getAllImagesData(),
              //FirebaseFirestore.instance.collection('images').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<QueryDocumentSnapshot> allDocuments = [];

                for (var querySnapshotList in snapshot.data!) {
                  for (var doc in querySnapshotList.docs) {
                    allDocuments.add(doc);
                  }
                }

                // var documents = snapshot.data!.docs;
                allDocuments.shuffle();

                // List<String> documentIds =
                //     snapshot.data!.docs.map((doc) => doc.id).toList();
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: allDocuments.length,
                  itemBuilder: (context, index) {
                    var imageUrl = allDocuments[index]
                        .get('link'); //documents[index]['link'];
                    // Replace 'your_image_field' with the actual field containing the image URL.
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
            ),
    );
  }
}
