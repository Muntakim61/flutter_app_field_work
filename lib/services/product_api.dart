import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductApi {
  static const _base = 'https://dummyjson.com/products';
  static const limit = 12;

  Future<ProductPage> fetchProducts({int skip = 0}) async {
    final res = await http.get(Uri.parse('$_base?limit=$limit&skip=$skip'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load products (${res.statusCode})');
    }
    final data = jsonDecode(res.body);
    return ProductPage(
      products: (data['products'] as List)
          .map((p) => Product.fromJson(p))
          .toList(),
      total: data['total'],
    );
  }

  Future<Product> fetchProductDetail(int id) async {
    final res = await http.get(Uri.parse('$_base/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load product (${res.statusCode})');
    }
    return Product.fromJson(jsonDecode(res.body));
  }

  Future<ProductPage> searchProducts(String query) async {
    final uri = Uri.parse('$_base/search').replace(
      queryParameters: {'q': query.trim()},
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Search failed (${res.statusCode})');
    }
    final data = jsonDecode(res.body);
    return ProductPage(
      products: (data['products'] as List)
          .map((p) => Product.fromJson(p))
          .toList(),
      total: data['total'],
    );
  }
}

class ProductPage {
  final List<Product> products;
  final int total;
  ProductPage({required this.products, required this.total});
}
