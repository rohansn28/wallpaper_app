// import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/full_Screen.dart';

class GalleryWallpaperScreen extends StatelessWidget {
  const GalleryWallpaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('collection_list').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          ); //CircularProgressIndicator();
        }
        final List<DocumentSnapshot> documents = snapshot.data!.docs;
        // List<String> documentIds =
        //     snapshot.data!.docs.map((doc) => doc.id).toList();

        return GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            // String url = snapshot.data!.docs.elementAt(index)['link'];
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: GestureDetector(
                onTap: () async {
                  var collection =
                      FirebaseFirestore.instance.collection('collection_list');

                  var allDocs = collection.get().then((querySnapshot) {
                    print("Successfully completed");
                    for (var docSnapshot in querySnapshot.docs) {
                      print('${docSnapshot.id} => ${docSnapshot.data()}');
                    }
                  });
                },
                child: GridTile(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      Image.network(
                        'https://via.placeholder.com/150', // Replace with your image URL
                        fit: BoxFit.cover,
                      ),
                      // Text in the center
                      Center(
                        child: Text(
                          snapshot.data!.docs
                              .elementAt(index)['category']
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // child: Text(
                  //   snapshot.data!.docs.elementAt(index)['category'].toString(),
                  // ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}


// class GalleryWallpaperScreen extends StatefulWidget {
//   const GalleryWallpaperScreen({super.key});

//   @override
//   State<GalleryWallpaperScreen> createState() => _GalleryWallpaperScreenState();
// }

// class _GalleryWallpaperScreenState extends State<GalleryWallpaperScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('images').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           ); //CircularProgressIndicator();
//         }
//         final List<DocumentSnapshot> documents = snapshot.data!.docs;
//         List<String> documentIds =
//             snapshot.data!.docs.map((doc) => doc.id).toList();

//         return GridView.builder(
//           scrollDirection: Axis.vertical,
//           physics: const BouncingScrollPhysics(),
//           shrinkWrap: true,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisSpacing: 16.0,
//             crossAxisSpacing: 16.0,
//           ),
//           itemCount: documents.length,
//           itemBuilder: (BuildContext context, int index) {
//             String url = snapshot.data!.docs.elementAt(index)['link'];
//             return Padding(
//               padding: const EdgeInsets.all(1.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => FullScreen(
//                         documents: documents,
//                         urlLink: url,
//                         documentId: documentIds[index],
//                         isFavourite:
//                             snapshot.data!.docs.elementAt(index)['isfavourite'],
//                       ),
//                     ),
//                   );
//                 },
//                 child: GridTile(
//                   child: Container(
//                     child: CachedNetworkImage(
//                       width: 200,
//                       height: 200,
//                       imageUrl: snapshot.data!.docs.elementAt(index)['link'],
//                       imageBuilder: (context, imageProvider) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             image: DecorationImage(
//                                 image: imageProvider,
//                                 fit: BoxFit.cover,
//                                 colorFilter: ColorFilter.mode(
//                                     Colors.black54.withOpacity(0.2),
//                                     BlendMode.colorBurn)),
//                           ),
//                         );
//                       },
//                       placeholder: (context, url) => const Text('Loading...'),
//                       //const CircularProgressIndicator(),
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
