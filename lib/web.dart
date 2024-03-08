import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:wallpaper_app/models/categorymodel.dart';
import 'package:wallpaper_app/models/wallpapermodel.dart';

Future<List<Wallpaper>> fetchData() async {
  var url = Uri.parse('http://10.0.2.2:8000/api/images');
  var response = await http.get(url);

  List<Wallpaper> wallpapers = wallpaperFromJson(response.body.toString());

  return wallpapers;
}

Future<List<Wallpaper>> fetchCarData(String value) async {
  var url = Uri.parse('http://10.0.2.2:8000/api/images/$value');
  var response = await http.get(url);

  List<Wallpaper> wallpapers = wallpaperFromJson(response.body.toString());

  return wallpapers;
}

Future<List<CategoryWall>> fetchCategoryData() async {
  var url = Uri.parse('http://10.0.2.2:8000/api/images/category');
  var response = await http.get(url);

  List<CategoryWall> category = categoryWallFromJson(response.body.toString());

  return category;
}

Future<int> checkAndAddValidUrls() async {
  List<String> validUrls = [];
  var count = 0;
  var i = 1;

  var url = 'https://unfoldedtechnews.website/cars/Car${i}.png';
  // var urlNext = 'https://unfoldedtechnews.website/cars/Car${i + 1}.png';

  while (i != 0) {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        validUrls.add(url);
        count++;
        i++;
      } else {
        i = 0;
      }
    } catch (e) {
      print('Error checking URL: $e');
    }
  }
  print('this is working');

  // for (String url in urls) {
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       validUrls.add(url);
  //     }
  //   } catch (e) {
  //     print('Error checking URL: $e');
  //   }
  // }

  return validUrls.length;
}
