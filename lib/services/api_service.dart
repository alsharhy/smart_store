import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Using dummyjson.com as fakestoreapi.com is currently down
  static const String baseUrl = "https://dummyjson.com/products";

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse("$baseUrl?limit=30"));

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch products: ${response.statusCode}");
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    final List data = body["products"];

    return data.map((e) => Product.fromJson(e)).toList();
  }
}
