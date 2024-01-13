import 'package:animated_icon/animated_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_app/utils/google_ads.dart';
import 'package:wallpaper_app/utils/local_favorites.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

final downloadCountProvider = StateProvider<int>((ref) => 0);

class FullScreen extends ConsumerStatefulWidget {
  const FullScreen({
    super.key,
    this.documents,
    required this.urlLink,
    required this.documentId,
  });

  final List<DocumentSnapshot>? documents;
  final String urlLink;
  final String documentId;

  @override
  ConsumerState<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends ConsumerState<FullScreen> {
  late AdManager adManager;
  bool isAdLoaded = false;
  @override
  void initState() {
    super.initState();
    adManager = AdManager(onAdLoaded: (bool loaded) {
      setState(() {
        isAdLoaded = loaded;
      });
    });
    adManager.initBannerAd();

    adManager.initInterstitialAd();
  }

  @override
  void dispose() {
    adManager.disposeBannerAd();
    super.dispose();
  }

  Future<void> toggleFavoriteStatus(
      String documentId, bool currentStatus) async {
    CollectionReference imagesCollection =
        FirebaseFirestore.instance.collection('images');

    // Update the 'favorite' field to the opposite of its current status
    await imagesCollection.doc(documentId).update({
      'isfavourite': !currentStatus,
    });
  }

  // Function to request storage permission
  // Future<bool> requestStoragePermission() async {
  //   bool permissionStatus;
  //   final deviceInfo = await DeviceInfoPlugin().androidInfo;

  //   if (deviceInfo.version.sdkInt > 32) {
  //     permissionStatus = await Permission.photos.request().isGranted;
  //   } else {
  //     permissionStatus = await Permission.storage.request().isGranted;
  //   }
  //   return permissionStatus;
  // }

  // Future<void> downloadWallpaper(BuildContext context, WidgetRef ref) async {
  //   bool hasPermission = await requestStoragePermission();

  //   if (hasPermission) {
  //     try {
  //       Directory? directory = await getExternalStorageDirectory();
  //       if (directory == null) {
  //         // Handle the case where getExternalStorageDirectory returns null
  //         print('Error: External storage directory is null');
  //         return;
  //       }

  //       var file = await DefaultCacheManager().getSingleFile(widget.urlLink);

  //       // Save the file to device storage
  //       String path = directory.path;

  //       File imageFile = File('$path/${widget.documentId}.jpg');

  //       await imageFile.writeAsBytes(await file.readAsBytes());

  //       // Save the file to the gallery
  //       await ImageGallerySaver.saveFile(imageFile.path);

  //       // Increment the download counter using Riverpod
  //       ref.read(downloadCountProvider.notifier).state++;

  //       // Check if the threshold is reached
  //       if (ref.read(downloadCountProvider.notifier).state == 2) {
  //         // Display an ad (replace this with your ad display logic)
  //         adManager.interstitialAd.show();
  //         // Reset the counter after displaying the ad
  //         ref.read(downloadCountProvider.notifier).state = 0;
  //       }

  //       // Show a snackbar indicating successful download
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Wallpaper downloaded successfully'),
  //         ),
  //       );
  //     } catch (e) {
  //       // Handle errors if any
  //       //print('Error downloading wallpaper: $e');
  //       // Show a snackbar indicating the error
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Error downloading wallpaper'),
  //         ),
  //       );
  //     }
  //   } else {
  //     // Show a snackbar indicating the need for storage permission
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Storage permission required to download wallpaper'),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // print(documentId);
    var setas = {
      'Home': WallpaperManager.HOME_SCREEN,
      'Lock': WallpaperManager.LOCK_SCREEN,
      'Both': WallpaperManager.BOTH_SCREEN
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(78, 0, 0, 0),
        elevation: 0.0,
        actions: [
          FutureBuilder(
            future: LocalFavorites.favIcon(widget.urlLink),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AnimateIcon(
                  animateIcon: AnimateIcons.heart,
                  onTap: () {},
                  iconType: IconType.onlyIcon,
                  color: Colors.white,
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                IconData iconData =
                    snapshot.data! ? Icons.favorite : Icons.favorite_border;
                return IconButton(
                  icon: Icon(
                    iconData,
                    color: iconData == Icons.favorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      LocalFavorites.toggleFavorite(widget.urlLink);
                    });
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              widget.urlLink,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  var actionsheet = CupertinoActionSheet(
                    title: const Text('Set As'),
                    actions: [
                      CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop('Home');
                          },
                          child: const Text('Home')),
                      CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop('Lock');
                          },
                          child: const Text('Lock')),
                      CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop('Both');
                          },
                          child: const Text('Both'))
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        'Cancel',
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                  var option = await showCupertinoModalPopup(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) => actionsheet);

                  if (option != null) {
                    String url = widget.urlLink;
                    var cachedImage =
                        await DefaultCacheManager().getSingleFile(url);

                    //cropped image code starts here
                    // CroppedFile? croppedImage;

                    // if (cachedImage != null) {
                    //   croppedImage = await ImageCropper().cropImage(
                    //       sourcePath: cachedImage.path,
                    //       aspectRatio: CropAspectRatio(
                    //           ratioX: MediaQuery.of(context).size.width,
                    //           ratioY: MediaQuery.of(context).size.height),
                    //       uiSettings: [
                    //         AndroidUiSettings(
                    //             toolbarTitle: 'Crop Image',
                    //             toolbarColor: Colors.black,
                    //             toolbarWidgetColor: Colors.white,
                    //             hideBottomControls: true)
                    //       ]);
                    // }

                    // if (croppedImage != null) {
                    //   showDialog(
                    //     context: context,
                    //     builder: (c) {
                    //       return LoadingDialog(
                    //         message: "Loading Data",
                    //       );
                    //     },
                    //   );

                    // }
                    //image cropper code ends here
                    await WallpaperManager.setWallpaperFromFile(
                        cachedImage.path, setas[option]!);
                  }
                },
                child: const Text('Set as'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Share.share(widget.urlLink,
                      subject: 'My Favourite Wallpaper!');
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share'),
              ),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     downloadWallpaper(
              //       context,
              //       ref,
              //     );
              //   },
              //   icon: const Icon(Icons.file_download),
              //   label: const Text('Download'),
              // ),
            ],
          ),
          isAdLoaded
              ? SizedBox(
                  height: adManager.bannerAd.size.height.toDouble(),
                  width: adManager.bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: adManager.bannerAd),
                )
              : const SizedBox(
                  height: 20,
                )
        ],
      ),
    );
  }
}
