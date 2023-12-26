// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Future<void> fetchAndShuffleImages() async {
    try {
      setState(() {
        isLoading = true;
      });

      var querySnapshot =
          await FirebaseFirestore.instance.collection('images').get();
      documents = querySnapshot.docs.toList();
      documents.shuffle();
    } catch (e) {
      print('Error fetching or shuffling images: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchAndShuffleImages,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('images').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var documents = snapshot.data!.docs;
                documents.shuffle();

                List<String> documentIds =
                    snapshot.data!.docs.map((doc) => doc.id).toList();
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var imageUrl = documents[index]['link'];
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
                              documentId: documentIds[index],
                              isFavourite: false,
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
