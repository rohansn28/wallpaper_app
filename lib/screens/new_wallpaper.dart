import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wallpaper_app/full_Screen.dart';
import 'package:wallpaper_app/models/wallpapermodel.dart';
import 'package:wallpaper_app/web.dart';

class NewWallpaperScreen extends StatelessWidget {
  const NewWallpaperScreen({super.key});

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
    print(checkAndAddValidUrls());
    print('New wall screen');
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FutureBuilder(
        // future: fetchCarData('allwallpaper'),
        future: checkAndAddValidUrls(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Loading..."),
            );
          }
          // List<String>? wallpapers = snapshot.data;
          // print(wallpapers);
          // print(wallpapers!.length);
          // var itemcount = checkAndAddValidUrls();
          // print(itemcount);
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
              // itemCount: wallpapers!.length,
              itemBuilder: (BuildContext context, int index) {
                // Wallpaper wallpaper = wallpapers[index];

                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GestureDetector(
                    // onTap: () {
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (context) => FullScreen(
                    //         urlLink: wallpaper.wallUrl,
                    //       ),
                    //     ),
                    //   );
                    // },
                    child: GridTile(
                      child: CachedNetworkImage(
                        width: 200,
                        height: 200,
                        imageUrl: 'wallpapers[index]',
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
              },
            ),
          );
        },
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(4.0),
  //     child: FutureBuilder<Stream<List<QuerySnapshot>>>(
  //       future: getAllImagesDataStream(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: Text('Loading...'));
  //         }

  //         if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         }

  //         Stream<List<QuerySnapshot>> imagesDataStream =
  //             snapshot.data ?? Stream.value([]);

  //         List<QueryDocumentSnapshot> allDocuments = [];

  //         return StreamBuilder<List<QuerySnapshot>>(
  //             stream: imagesDataStream,
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const Text('Loading...');
  //               }

  //               if (snapshot.hasError) {
  //                 return Text('Error: ${snapshot.error}');
  //               }

  //               for (var snapshotdata in snapshot.data!) {
  //                 for (var data in snapshotdata.docs) {
  //                   allDocuments.add(data);
  //                 }
  //               }
  //               allDocuments.sort(
  //                 (a, b) => b['timestamp'].compareTo(a['timestamp']),
  //               );

  //               return GridView.builder(
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 2,
  //                   crossAxisSpacing: 8.0,
  //                   mainAxisSpacing: 8.0,
  //                 ),
  //                 itemCount: allDocuments.length,
  //                 itemBuilder: (context, index) {
  //                   var imageUrl = allDocuments[index].get('link');
  //                   return GestureDetector(
  //                     child: GridTile(
  //                       child: Image.network(
  //                         imageUrl,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                     onTap: () {
  //                       Navigator.of(context).push(
  //                         MaterialPageRoute(
  //                           builder: (context) => FullScreen(
  //                             urlLink: imageUrl,
  //                             documentId: allDocuments[index].id,
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   );
  //                 },
  //               );
  //             });
  //       },
  //     ),
  //   );
  // }
}
