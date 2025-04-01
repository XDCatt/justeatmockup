import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/';

  Future<List<Restaurant>> fetchRestaurants(String postcode) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$postcode'));
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> restaurantData = data['restaurants'] ?? [];
        return restaurantData
            .take(10) // Limit to 10 as said in the assignment
            .map((json) => Restaurant.fromJson(json))
            .toList();
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch restaurants: $e');
    }
  }
}