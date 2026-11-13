import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_api.dart';

class ProductProvider extends ChangeNotifier {
  final _api = ProductApi();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  int _skip = 0;
  int _total = 0;
  bool _isSearching = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _skip < _total;

  Future<void> fetchInitial() async {
    _skip = 0;
    _isSearching = false;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final page = await _api.fetchProducts(skip: 0);
      _products = page.products;
      _total = page.total;
      _skip = page.products.length;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoading || !hasMore || _isSearching) return;
    _isLoading = true;
    notifyListeners();

    try {
      final page = await _api.fetchProducts(skip: _skip);
      _products.addAll(page.products);
      _skip += page.products.length;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      return fetchInitial();
    }
    _isSearching = true;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final page = await _api.searchProducts(query);
      _products = page.products;
      _total = page.products.length;
      _skip = page.products.length;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => fetchInitial();
}
