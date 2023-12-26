import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/full_Screen.dart';

class NewWallpaperScreen extends StatefulWidget {
  const NewWallpaperScreen({super.key});

  @override
  State<NewWallpaperScreen> createState() => _NewWallpaperScreenState();
}

class _NewWallpaperScreenState extends State<NewWallpaperScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('images')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); //CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<String> imageUrls =
              snapshot.data!.docs.map((doc) => doc['link'].toString()).toList();

          print(imageUrls);

          // return ListView.builder(
          //   itemCount: imageUrls.length,
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Image.network(imageUrls[index]),
          //     );
          //   },
          // );
          List<String> documentIds =
              snapshot.data!.docs.map((doc) => doc.id).toList();
          return GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreen(
                          urlLink: imageUrls[index],
                          documentId: documentIds[index],
                          isFavourite: snapshot.data!.docs
                              .elementAt(index)['isfavourite'],
                        ),
                      ),
                    );
                  },
                  child: GridTile(
                    child: CachedNetworkImage(
                      width: 200,
                      height: 200,
                      imageUrl: snapshot.data!.docs.elementAt(index)['link'],
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
              );
            },
          );
        },
      ),
    );
  }
}
