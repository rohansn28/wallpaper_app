// import 'dart:html';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:wallpaper_app/full_Screen.dart';
import 'package:wallpaper_app/screens/category_screen.dart';

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

        //testing
        // var first = documents.elementAt(1).get('category');
        // var collection = FirebaseFirestore.instance.collection(first);

        // var check =
        //     collection.orderBy('timestamp', descending: true).limit(1).get();

        // var checkVal = check.then((value) {
        //   var someData = value.docs;
        //   var catUrl = someData[0].data()['link'];
        //   return catUrl;
        //   // print(catUrl);
        // });
        print(
            'assets/${snapshot.data!.docs.elementAt(0)['category'].toString()}.jpg');
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
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(
                          title: snapshot.data!.docs
                              .elementAt(index)['category']
                              .toString(),
                        ),
                      ),
                    );
                  },
                  child: GridTile(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/${snapshot.data!.docs.elementAt(index)['category'].toString()}.jpg',
                          fit: BoxFit.cover,
                        ),

                        // Text in the center
                        Center(
                          child: Text(
                            snapshot.data!.docs
                                .elementAt(index)['category']
                                .toString()
                                .toUpperCase(),
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
          ),
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
