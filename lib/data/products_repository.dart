import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:shop_app/models/product.dart';

abstract class _ProductRepositoryEvents {
  Future<List<Product>> fetchProducts();

  Future<String> addProduct(Product product);

  Future<int> deleteProduct(String productId);

  Future<int> updateProduct(Product updatedProduct);

  Future<int> setFavoriteProduct(String productId, bool isFavoriteStatus);
}

class ProductRepository implements _ProductRepositoryEvents {
  static const _url = 'https://flutter-shop-8a914.firebaseio.com/products';
  final String _authToken;
  final String _userId;

  ProductRepository(this._authToken, this._userId);

  @override
  Future<String> addProduct(Product product) async {
    // final prefs = await SharedPreferences.getInstance();
    // final authToken = prefs.getString('authToken');
    try {
      final response = await http.post(
        _url + '.json?auth=$_authToken',
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': _userId,
        }),
      );
      return json.decode(response.body)['name']; //Return Product ID
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<int> deleteProduct(String productId) async {
    // final prefs = await SharedPreferences.getInstance();
    // final authToken = prefs.getString('authToken');
    try {
      final response =
          await http.delete('$_url/$productId.json?auth=$_authToken');
      return response.statusCode;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<Product>> fetchProducts([bool filterByUser = false]) async {
    // final prefs = await SharedPreferences.getInstance();
    // final authToken = prefs.getString('authToken');
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    try {
      final response =
          await http.get('$_url.json?auth=$_authToken&$filterString');
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if (extractedData != null) {
        final userFavoritesResponse = await http
            .get('${_url}UserFavorites/$_userId.json?auth=$_authToken');

        final favoriteData = jsonDecode(userFavoritesResponse.body);

        extractedData.forEach((productId, productData) {
          loadedProducts.insert(
            0,
            Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              price: double.tryParse(productData['price'].toString()),
              imageUrl: productData['imageUrl'],
              isFavorite: favoriteData == null
                  ? false
                  : favoriteData[productId] ?? false,
            ),
          );
        });
      }

      return loadedProducts;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<int> setFavoriteProduct(
      String productId, bool isFavoriteStatus) async {
    // final prefs = await SharedPreferences.getInstance();
    // final authToken = prefs.getString('authToken');
    try {
      final response = await http.put(
        '${_url}UserFavorites/$_userId/$productId.json?auth=$_authToken',
        body: jsonEncode(isFavoriteStatus),
      );
      return response.statusCode;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<int> updateProduct(Product updatedProduct) async {
    // final prefs = await SharedPreferences.getInstance();
    // final authToken = prefs.getString('authToken');
    try {
      final response = await http.patch(
        '$_url/${updatedProduct.id}.json?auth=$_authToken',
        body: jsonEncode({
          'title': updatedProduct.title,
          'description': updatedProduct.description,
          'price': updatedProduct.price,
          'imageUrl': updatedProduct.imageUrl,
        }),
      );
      return response.statusCode;
    } catch (error) {
      throw error;
    }
  }
}
