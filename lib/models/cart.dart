import 'package:flutter/foundation.dart';

class CartItem {
  CartItem({
    @required this.id,
    @required this.title,
    @required this.productImageUrl,
    @required this.price,
    @required this.quantity,
  })  : assert(id != null),
        assert(title != null),
        assert(productImageUrl != null),
        assert(price != null),
        assert(quantity != null);

  final String id;
  final double price;
  final String productImageUrl;
  final int quantity;
  final String title;
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  double get totalCartAmount {
    var total = 0.0;

    _cartItems.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void addCartItem({
    String productId,
    String title,
    double price,
    String productImage,
  }) {
    //Check if the product is alrady on the cart then increase quantity
    if (_cartItems.containsKey(productId)) {
      //Update
      _cartItems.update(
        productId,
        (oldItem) => CartItem(
          id: oldItem.id,
          title: oldItem.title,
          productImageUrl: oldItem.productImageUrl,
          price: oldItem.price,
          quantity: oldItem.quantity + 1,
        ),
      );
    } else {
      //Add new cartitems
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          productImageUrl: productImage,
          price: price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeCartItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void removeSingleCartItem(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    }

    if (_cartItems[productId].quantity > 1) {
      _cartItems.update(
        productId,
        (oldItem) => CartItem(
          id: oldItem.id,
          title: oldItem.title,
          price: oldItem.price,
          productImageUrl: oldItem.productImageUrl,
          quantity: oldItem.quantity - 1,
        ),
      );
    } else {
      _cartItems.remove(productId);
    }

    notifyListeners();
  }

  void clearCartItems() {
    _cartItems.clear();
    notifyListeners();
  }
}
