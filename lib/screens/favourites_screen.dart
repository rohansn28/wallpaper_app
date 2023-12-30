import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/full_Screen.dart';
import 'package:wallpaper_app/utils/local_favorites.dart';

class FavoriteImagesList extends StatelessWidget {
  const FavoriteImagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: StreamBuilder<List<String>>(
        stream: LocalFavorites.favoritesStream(), // Update to use stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<String> favorites = snapshot.data ?? [];

          print(favorites.length);

          return GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            itemCount: favorites.length,
            itemBuilder: (BuildContext context, int index) {
              String url = favorites[index];
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreen(
                          urlLink: url,
                          documentId: favorites[index],
                        ),
                      ),
                    );
                  },
                  child: GridTile(
                    child: Container(
                      child: CachedNetworkImage(
                        width: 200,
                        height: 200,
                        imageUrl: favorites[index],

                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black54.withOpacity(0.2),
                                      BlendMode.colorBurn)),
                            ),
                          );
                        },
                        placeholder: (context, url) => const Text('Loading...'),
                        //const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FavoriteImageTile extends StatelessWidget {
  final String imageUrl;

  FavoriteImageTile({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: const Text('Favorite Image'),
            trailing: IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                LocalFavorites.toggleFavorite(imageUrl);
              },
            ),
          ),
        ],
      ),
    );
  }
}


// class FavouriteWallpaperScreen extends StatefulWidget {
//   const FavouriteWallpaperScreen({super.key});

//   @override
//   State<FavouriteWallpaperScreen> createState() =>
//       _FavouriteWallpaperScreenState();
// }

// class _FavouriteWallpaperScreenState extends State<FavouriteWallpaperScreen> {
//   // Future<void> toggleFavoriteStatus(
//   //     String documentId, bool currentStatus) async {
//   //   CollectionReference imagesCollection =
//   //       FirebaseFirestore.instance.collection('images');

//   //   // Update the 'favorite' field to the opposite of its current status
//   //   await imagesCollection.doc(documentId).update({
//   //     'favorite': !currentStatus,
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Favorites'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('images')
//             .where('isfavourite',
//                 isEqualTo: true) // Filter only favorite images
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             ); //CircularProgressIndicator();
//           }
//           final List<DocumentSnapshot> documents = snapshot.data!.docs;

//           // ... (build UI based on favorite images)
//           List<String> documentIds =
//               snapshot.data!.docs.map((doc) => doc.id).toList();

//           return GridView.builder(
//             scrollDirection: Axis.vertical,
//             physics: const BouncingScrollPhysics(),
//             shrinkWrap: true,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 16.0,
//               crossAxisSpacing: 16.0,
//             ),
//             itemCount: documents.length,
//             itemBuilder: (BuildContext context, int index) {
//               String url = snapshot.data!.docs.elementAt(index)['link'];
//               return Padding(
//                 padding: const EdgeInsets.all(1.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => FullScreen(
//                           documents: documents,
//                           urlLink: url,
//                           documentId: documentIds[index],
//                         ),
//                       ),
//                     );
//                   },
//                   child: GridTile(
//                     child: Container(
//                       child: CachedNetworkImage(
//                         width: 200,
//                         height: 200,
//                         imageUrl: snapshot.data!.docs.elementAt(index)['link'],
//                         imageBuilder: (context, imageProvider) {
//                           return Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               image: DecorationImage(
//                                   image: imageProvider,
//                                   fit: BoxFit.cover,
//                                   colorFilter: ColorFilter.mode(
//                                       Colors.black54.withOpacity(0.2),
//                                       BlendMode.colorBurn)),
//                             ),
//                           );
//                         },
//                         placeholder: (context, url) => const Text('Loading...'),
//                         //const CircularProgressIndicator(),
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.error),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
