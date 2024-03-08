import 'package:cached_network_image/cached_network_image.dart';
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

          // print(favorites.length);

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
                        ),
                      ),
                    );
                  },
                  child: GridTile(
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

  const FavoriteImageTile({super.key, required this.imageUrl});

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
              icon: const Icon(Icons.favorite_border),
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
