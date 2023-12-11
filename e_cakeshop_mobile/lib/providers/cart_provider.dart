import 'package:e_cakeshop_mobile/models/cart.dart';
import 'package:e_cakeshop_mobile/models/proizvod.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

class CartProvider with ChangeNotifier {
  Cart cart = Cart();

  void addToCart(Proizvod product) {
    CartItem? existingItem = findInCart(product);

    if (existingItem != null) {
      existingItem.count++;
    } else {
      cart.items.add(CartItem(product, 1));
    }

    notifyListeners();
  }

  void removeFromCart(Proizvod product) {
    cart.items.removeWhere((item) => item.product == product);
    notifyListeners();
  }

  CartItem? findInCart(Proizvod product) {
    return cart.items.firstWhereOrNull((item) => item.product == product);
  }

  double get totalPrice {
    return cart.items.fold<double>(0.0, (previousValue, item) {
      return previousValue + (item.product.cijena! * item.count);
    });
  }

  void clearCart() {
    cart.items.clear();
    notifyListeners();
  }
}
