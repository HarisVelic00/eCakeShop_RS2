import 'package:e_cakeshop_mobile/models/cart.dart';
import 'package:e_cakeshop_mobile/models/proizvod.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

class CartProvider with ChangeNotifier {
  Cart cart = Cart();
  addToCart(Proizvod product) {
    if (findInCart(product) != null) {
      findInCart(product)?.count++;
    } else {
      cart.items.add(CartItem(product, 1));
    }

    notifyListeners();
  }

  removeFromCart(Proizvod product) {
    cart.items
        .removeWhere((item) => item.product.proizvodID == product.proizvodID);
    notifyListeners();
  }

  CartItem? findInCart(Proizvod product) {
    CartItem? item = cart.items.firstWhereOrNull(
        (item) => item.product.proizvodID == product.proizvodID);
    return item;
  }

  double get totalPrice {
    return cart.items.fold<double>(0.0, (previousValue, item) {
      return previousValue + (item.product.cijena! * item.count);
    });
  }
}
