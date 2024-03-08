import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/full_Screen.dart';
import 'package:wallpaper_app/models/wallpapermodel.dart';
import 'package:wallpaper_app/web.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.title});
  final String title;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // List<String> imageUrls = [];
  // int currentPage = 1; // Current page number
  // bool isLoading = false; // Flag to track whether images are being loaded
  // bool hasMoreImages = true; // Flag to track if there are more images to fetch

  // final int batchSize = 4; // Number of images to fetch per batch

  // @override
  // void initState() {
  //   super.initState();
  //   fetchImages();
  // }

  // Future<void> fetchImages() async {
  //   if (isLoading || !hasMoreImages) return;

  //   setState(() {
  //     isLoading = true;
  //   });

  //   final startImageIndex = (currentPage - 1) * batchSize + 1;
  //   final endImageIndex = startImageIndex + batchSize - 1;

  //   try {
  //     for (var i = startImageIndex; i <= endImageIndex; i++) {
  //       final url =
  //           'https://unfoldedtechnews.website/${widget.title}/${widget.title.toLowerCase()}${i}.jpg';
  //       final response = await http.get(Uri.parse(url));

  //       if (response.statusCode == 200) {
  //         imageUrls.add(url);
  //       } else {
  //         // If any image is missing, set hasMoreImages to false
  //         setState(() {
  //           hasMoreImages = false;
  //         });
  //         break;
  //       }
  //     }

  //     setState(() {
  //       currentPage++; // Move to the next page for the next request
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error fetching images: $e');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.title);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
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
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            var url =
                'https://unfoldedtechnews.website/${widget.title}/${widget.title}${index + 1}.jpg';
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
          },
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(title: Text(widget.title.toUpperCase())),
    //   body: FutureBuilder(
    //     future: fetchCarData(widget.title),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) {
    //         return const Center(
    //           child: Text("Loading..."),
    //         );
    //       }
    //       List<Wallpaper>? wallpapers = snapshot.data;
    //       return Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: GridView.builder(
    //           scrollDirection: Axis.vertical,
    //           physics: const BouncingScrollPhysics(),
    //           shrinkWrap: true,
    //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: 2,
    //             mainAxisSpacing: 8.0,
    //             crossAxisSpacing: 8.0,
    //           ),
    //           itemCount: wallpapers!.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             Wallpaper wallpaper = wallpapers[index];

    //             return Padding(
    //               padding: const EdgeInsets.all(1.0),
    //               child: GestureDetector(
    //                 onTap: () {
    //                   Navigator.of(context).push(
    //                     MaterialPageRoute(
    //                       builder: (context) => FullScreen(
    //                         urlLink: wallpaper.wallUrl,
    //                       ),
    //                     ),
    //                   );
    //                 },
    //                 child: GridTile(
    //                   child: CachedNetworkImage(
    //                     width: 200,
    //                     height: 200,
    //                     imageUrl: wallpaper.wallUrl,
    //                     imageBuilder: (context, imageProvider) {
    //                       return Container(
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(10),
    //                           image: DecorationImage(
    //                             image: imageProvider,
    //                             fit: BoxFit.cover,
    //                             // colorFilter: ColorFilter.mode(
    //                             //   Colors.black54.withOpacity(0.2),
    //                             //   BlendMode.colorBurn,
    //                             // ),
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                     placeholder: (context, url) => const Text('Loading...'),
    //                     errorWidget: (context, url, error) =>
    //                         const Icon(Icons.error),
    //                   ),
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
