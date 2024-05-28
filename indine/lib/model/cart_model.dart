import 'package:flutter/material.dart';
import 'package:indine/item_tile.dart';

class Product {
  int id;
  String name;
  double price;
  int quantity;

  Product({required this.id, required this.name, required this.price, required this.quantity});
}


class CartProvider extends ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }
  void removeItem(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  // Implement other methods like removeFromCart, updateCartItemQuantity, etc.
}
