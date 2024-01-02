import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
