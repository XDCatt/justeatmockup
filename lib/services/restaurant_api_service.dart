// lib/data/remote/restaurant_remote_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class RestaurantApiService {
  static const baseUrl = 'https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/';

  final http.Client client;
  final Logger logger;

  RestaurantApiService({
    http.Client? client,
    Logger? logger,
  })  : client = client ?? http.Client(),
        logger = logger ?? Logger();

  /// Fetches the raw **JSON list** of restaurants from the network.
  ///
  /// Throws [Exception] on any non-200 status or network error.
  Future<List<Map<String, dynamic>>> fetchRestaurantsRaw(String postcode) async {
    try {
      final res = await client.get(Uri.parse('$baseUrl$postcode'));
      logger.i(res.body);

      if (res.statusCode != 200) {
        throw Exception('API returned status code ${res.statusCode}');
      }

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final List<dynamic> list = data['restaurants'] ?? [];

      return List<Map<String, dynamic>>.from(list);
    } catch (e) {
      throw Exception('Failed to fetch restaurants: $e');
    }
  }
}
