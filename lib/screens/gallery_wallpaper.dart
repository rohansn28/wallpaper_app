import 'package:flutter/material.dart';
import 'package:wallpaper_app/screens/category_screen.dart';

class GalleryWallpaperScreen extends StatelessWidget {
  const GalleryWallpaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List catList = ['anime', 'car', 'nature', 'image', 'people'];
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
        itemCount: catList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                      title: catList[index].toLowerCase(),
                    ),
                  ),
                );
              },
              child: GridTile(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Text(catList[index]),
                    Image.asset(
                      'assets/${catList[index]}.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(
                                0.8), // Darker color at the corners
                            Colors.black.withOpacity(0.5), // Medium darkness
                            Colors.black.withOpacity(
                                0.3), // Lighter color in the center
                          ],
                        ),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                    ),

                    // Text in the center
                    Center(
                      child: Text(
                        catList[index].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
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
  }
}
