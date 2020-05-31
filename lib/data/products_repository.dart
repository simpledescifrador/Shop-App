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
  static const url = 'https://flutter-shop-8a914.firebaseio.com/products';

  @override
  Future<String> addProduct(Product product) async {
    try {
      final response = await http.post(
        url + '.json',
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      return json.decode(response.body)['name']; //Return Product ID
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<int> deleteProduct(String productId) async {
    try {
      final response = await http.delete('$url/$productId.json');
      return response.statusCode;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(url + '.json');
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.insert(
          0,
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: double.tryParse(productData['price'].toString()),
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'] as bool,
          ),
        );
      });

      return loadedProducts;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<int> setFavoriteProduct(
      String productId, bool isFavoriteStatus) async {
    try {
      final response = await http.patch(
        '$url/$productId.json',
        body: jsonEncode({
          'isFavorite': isFavoriteStatus,
        }),
      );
      return response.statusCode;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<int> updateProduct(Product updatedProduct) async {
    try {
      final response = await http.patch(
        '$url/${updatedProduct.id}.json',
        body: jsonEncode({
          'title': updatedProduct.title,
          'description': updatedProduct.description,
          'price': updatedProduct.price,
          'imageUrl': updatedProduct.imageUrl,
          'isFavorite': updatedProduct.isFavorite,
        }),
      );
      return response.statusCode;
    } catch (error) {
      throw error;
    }
  }
}
