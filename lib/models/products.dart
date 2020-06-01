import 'package:flutter/material.dart';
import 'package:shop_app/data/products_repository.dart';

import 'package:shop_app/models/product.dart';
import 'package:shop_app/utils/http_exception.dart';

class Products with ChangeNotifier {
  static const baseUrl = 'https://flutter-shop-8a914.firebaseio.com';

  String authToken;
  String userId;

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'IPhone X',
    //   description:
    //       'The iPhone X was Apple\'s flagship 10th anniversary iPhone featuring a 5.8-inch OLED display, facial recognition and 3D camera functionality, a glass body, and an A11 Bionic processor.',
    //   price: 999,
    //   imageUrl:
    //       'https://www.apple.com/newsroom/images/product/iphone/standard/iphonex_front_back_glass_big.jpg.large.jpg',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Xbox One X',
    //   description:
    //       'The Xbox One is an eighth-generation home video game console developed by Microsoft. Announced in May 2013, it is the successor to Xbox 360 and the third console in the Xbox series of video game consoles. ... Microsoft marketed the device as an "all-in-one entertainment system", hence the name \'Xbox One\'.',
    //   price: 650,
    //   imageUrl:
    //       'https://cdn.vox-cdn.com/thumbor/Q6U1XMVx8mRUcaYmP5Me1_eP7pk=/0x0:950x623/1200x800/filters:focal(399x236:551x388)/cdn.vox-cdn.com/uploads/chorus_image/image/60345327/Xbox_One_X_Screenshot_05.0.jpg',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Xiaomi  Redmi 9s',
    //   description:
    //       'The phone is powered by Octa core (2.3 GHz, Dual core, Kryo 465 + 1.8 GHz, Hexa Core, Kryo 465) processor. It runs on the Qualcomm Snapdragon 720G Chipset. It has 4 GB RAM and 64 GB internal storage.',
    //   price: 200,
    //   imageUrl:
    //       'https://cnet4.cbsistatic.com/img/PIwhzdf2wUYhy9XjLk20GbVlWdY=/940x0/2020/03/23/fb734368-c213-4480-a8eb-b9cb5052c4d9/j6a-mix2-jpeg.jpg',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Logitech G102 Prodigy',
    //   description:
    //       'A responsive, accurate gaming mouse is super important when you’re gaming and that office rodent that came with your PC could well be holding you back from greatness online. If you’re looking to get the drop on someone in Fortnite or Apex Legends, you don’t want an uncomfortable, unresponsive mouse ruining your game.',
    //   price: 37.99,
    //   imageUrl: 'https://cf.shopee.ph/file/0b515dade6e19709d516fa0eab562c78',
    // ),
  ];

  List<Product> get items => _items;

  List<Product> get favoriteProducts =>
      _items.where((product) => product.isFavorite).toList();

  Product getProductById(String id) =>
      _items.firstWhere((product) => id == product.id);

  Future<void> loadProducts() async {
    try {
      _items = await ProductRepository(authToken, userId).fetchProducts();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> loadUserProducts() async {
    try {
      _items = await ProductRepository(authToken, userId).fetchProducts(true);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      product.id =
          await ProductRepository(authToken, userId).addProduct(product);
      _items.insert(0, product);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final productIndex =
        _items.indexWhere((product) => product.id == updatedProduct.id);
    try {
      if (productIndex >= 0) {
        final responseStatusCode = await ProductRepository(authToken, userId)
            .updateProduct(updatedProduct);

        if (responseStatusCode >= 400) {
          throw HttpException('Failed to update the product!');
        } else {
          _items[productIndex] = updatedProduct;
          notifyListeners();
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeProduct(String id) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[productIndex];
    if (productIndex >= 0) {
      _items.removeAt(productIndex);
      notifyListeners();

      final responseStatusCode =
          await ProductRepository(authToken, userId).deleteProduct(id);

      if (responseStatusCode >= 400) {
        _items.insert(productIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete the product');
      }
      existingProduct = null;
    }
  }

  void refreshProductList() {
    notifyListeners();
  }
}
