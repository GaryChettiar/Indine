import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final double price;
  int quantity;
  
  CartItem({required this.name, required this.price, this.quantity = 1});
}

class CartModel with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(String name, double price) {
    for (var item in _items) {
      if (item.name == name) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(name: name, price: price));
    notifyListeners();
  }

  void removeItem(String name) {
    _items.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  double get totalPrice => _items.fold(0.0, (total, current) => total + (current.price * current.quantity));
}
