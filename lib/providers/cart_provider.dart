import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  static const String _cartKey = 'cart_data';

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get subtotal => totalPrice;
  double get shipping => totalPrice > 0 ? (totalPrice > 100 ? 0 : 9.99) : 0;
  double get tax => totalPrice * 0.08;
  double get grandTotal => subtotal + shipping + tax;

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int quantityOf(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: Product(
        id: '', name: '', category: '', price: 0, originalPrice: 0,
        rating: 0, reviewCount: 0, image: '', images: [], description: '',
        inStock: false,
      )),
    );
    return item.product.id.isEmpty ? 0 : item.quantity;
  }

  void addToCart(Product product) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    _saveCart();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCart();
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      _saveCart();
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      _saveCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  Future<void> loadCart(List<Product> allProducts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        final List<dynamic> cartData = jsonDecode(cartJson);
        _items.clear();
        for (final item in cartData) {
          final product = allProducts.firstWhere(
            (p) => p.id == item['productId'],
            orElse: () => Product(
              id: '', name: '', category: '', price: 0, originalPrice: 0,
              rating: 0, reviewCount: 0, image: '', images: [], description: '',
              inStock: false,
            ),
          );
          if (product.id.isNotEmpty) {
            _items.add(CartItem(product: product, quantity: item['quantity']));
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = _items
          .map((item) => {
                'productId': item.product.id,
                'quantity': item.quantity,
              })
          .toList();
      await prefs.setString(_cartKey, jsonEncode(cartData));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }
}
