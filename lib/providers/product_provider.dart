import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../models/order.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  List<Order> _orders = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _allProducts;
  List<String> get categories => _categories;
  List<Order> get orders => _orders;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/products.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);

      _allProducts =
          (data['products'] as List).map((p) => Product.fromJson(p)).toList();
      _categories = List<String>.from(data['categories']);
      _orders =
          (data['orders'] as List).map((o) => Order.fromJson(o)).toList();
      _filteredProducts = List.from(_allProducts);
    } catch (e) {
      debugPrint('Error loading products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index] = Order(
        id: _orders[index].id,
        date: _orders[index].date,
        status: 'Cancelled',
        total: _orders[index].total,
        items: _orders[index].items,
      );
      notifyListeners();
    }
  }

  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}