import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:wallpaper/categories.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:wallpaper_app/full_Screen.dart';
import 'package:wallpaper_app/screens/favourites_screen.dart';
import 'package:wallpaper_app/screens/gallery_wallpaper.dart';
import 'package:wallpaper_app/screens/new_wallpaper.dart';
import 'package:wallpaper_app/screens/wallpaper_suffle_screen.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:wallpaper_app/loading.dart';
// import 'package:wallpaper/sucessdialog.dart';

class Popular extends StatefulWidget {
  const Popular({super.key});

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final List<String> tabTitles = ['Gallery', 'Recent', 'Trending', 'Random'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this); // Adjust the length based on the number of tabs
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Tab is changing, update the app bar title
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _tabController.index = 0;
                  Navigator.of(context).pop();
                  // _handleTabSelection();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                setState(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          FavoriteImagesList(), //const FavouriteWallpaperScreen(),
                    ),
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.paid),
              title: const Text('Remove Ads'),
              onTap: () {
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.textsms_rounded),
              title: const Text('Rate Us'),
              onTap: () {
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                setState(() {});
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(tabTitles[_tabController.index]),
        centerTitle: true,
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(4.0),
      //   child: StreamBuilder<QuerySnapshot>(
      //     stream: FirebaseFirestore.instance.collection('images').snapshots(),
      //     builder: (context, snapshot) {
      //       if (!snapshot.hasData) {
      //         return const CircularProgressIndicator();
      //       }
      //       final List<DocumentSnapshot> documents = snapshot.data!.docs;
      //       return GridView.builder(
      //         scrollDirection: Axis.vertical,
      //         physics: const BouncingScrollPhysics(),
      //         shrinkWrap: true,
      //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //           crossAxisCount: 2,
      //           mainAxisSpacing: 16.0,
      //           crossAxisSpacing: 16.0,
      //         ),
      //         itemCount: documents.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           String url = snapshot.data!.docs.elementAt(index)['link'];
      //           return Padding(
      //             padding: const EdgeInsets.all(1.0),
      //             child: GestureDetector(
      //               onTap: () {
      //                 Navigator.of(context).push(
      //                   MaterialPageRoute(
      //                     builder: (context) => FullScreen(
      //                       documents: documents,
      //                       urlLink: url,
      //                     ),
      //                   ),
      //                 );
      //               },
      //               child: GridTile(
      //                 child: Container(
      //                   child: CachedNetworkImage(
      //                     width: 200,
      //                     height: 200,
      //                     imageUrl:
      //                         snapshot.data!.docs.elementAt(index)['link'],
      //                     imageBuilder: (context, imageProvider) {
      //                       return Container(
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(10),
      //                           image: DecorationImage(
      //                               image: imageProvider,
      //                               fit: BoxFit.cover,
      //                               colorFilter: ColorFilter.mode(
      //                                   Colors.black54.withOpacity(0.2),
      //                                   BlendMode.colorBurn)),
      //                         ),
      //                       );
      //                     },
      //                     placeholder: (context, url) =>
      //                         const Text('Loading...'),
      //                     //const CircularProgressIndicator(),
      //                     errorWidget: (context, url, error) =>
      //                         const Icon(Icons.error),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: TabBarView(
              controller: _tabController,
              children: const [
                GalleryWallpaperScreen(),
                NewWallpaperScreen(),
                WallpaprSuffleScreen(),
              ],
            ),
          ),
          // Navigation bar with swipe effect
          Container(
            color: Colors.blue, // Customize the color as needed
            child: Material(
              color: Colors.black,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.image)),
                  Tab(icon: Icon(Icons.fiber_new)),
                  Tab(icon: Icon(Icons.shuffle)),
                ],
              ),
            ),
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (context) =>
          //                   const GalleryWallpaperScreen(),
          //             ),
          //           );
          //         },
          //         style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.transparent),
          //         child: const Icon(Icons.image),
          //       ),
          //     ),
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (context) => const NewWallpaperScreen(),
          //             ),
          //           );
          //         },
          //         style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.transparent),
          //         child: const Icon(Icons.fiber_new),
          //       ),
          //     ),
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (context) =>
          //                   const TreningWallpaperScreen(),
          //             ),
          //           );
          //         },
          //         style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.transparent),
          //         child: const Icon(Icons.trending_up),
          //       ),
          //     ),
          //     Expanded(
          //       child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (context) => const WallpaprSuffleScreen(),
          //             ),
          //           );
          //         },
          //         style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.transparent),
          //         child: const Icon(Icons.shuffle),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
