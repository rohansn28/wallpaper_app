import 'package:flutter/material.dart';
import 'package:wallpaper_app/screens/favourites_screen.dart';
import 'package:wallpaper_app/screens/gallery_wallpaper.dart';
import 'package:wallpaper_app/screens/new_wallpaper.dart';
import 'package:wallpaper_app/screens/wallpaper_suffle_screen.dart';

class Popular extends StatefulWidget {
  const Popular({super.key});

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final List<String> tabTitles = ['Gallery', 'Recent', 'Random'];

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
                          const FavoriteImagesList(), //const FavouriteWallpaperScreen(),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(tabTitles[_tabController.index]),
        centerTitle: true,
      ),
      body: Column(
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
        ],
      ),
    );
  }
}
