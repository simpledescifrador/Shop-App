import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  Product({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite = false,
  })  : this.id = id,
        this.title = title,
        this.description = description,
        this.price = price,
        this.imageUrl = imageUrl,
        this.isFavorite = isFavorite;

  String description;
  String id;
  String imageUrl;
  bool isFavorite;
  double price;
  String title;

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
