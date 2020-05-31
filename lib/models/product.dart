import 'package:flutter/foundation.dart';
import 'package:shop_app/data/products_repository.dart';

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

  void _setFavoriteStatus(bool newStatus) {
    isFavorite = newStatus;
    notifyListeners();
  }

  void toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite; //Change Favorite Status
    notifyListeners();

    try {
      final responseStatusCode =
          await ProductRepository().setFavoriteProduct(id, isFavorite);

      if (responseStatusCode >= 400) {
        //Rollback changes
        _setFavoriteStatus(oldStatus);
      }
    } catch (error) {
      //Rollback changes
      _setFavoriteStatus(oldStatus);
      throw error;
    }
  }
}
