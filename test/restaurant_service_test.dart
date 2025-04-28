import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:logger/logger.dart';

import 'package:justeatmockup/services/restaurant_api_service.dart'; 

// Step 1: Generate mocks using mockito
@GenerateMocks([http.Client, Logger])
import 'restaurant_service_test.mocks.dart';

void main() {
  group('RestaurantApiService', () {
    late MockClient mockClient;
    late MockLogger mockLogger;
    late RestaurantApiService service;

    setUp(() {
      mockClient = MockClient();
      mockLogger = MockLogger();
      service = RestaurantApiService(client: mockClient, logger: mockLogger);
    });

    test('fetchRestaurantsRaw returns list of restaurants on success', () async {
      final postcode = 'EC4M7RF';
      final expectedJson = {
        'restaurants': [
          {'name': 'Restaurant A'},
          {'name': 'Restaurant B'}
        ]
      };

      // Mock the HTTP response
      when(mockClient.get(Uri.parse('${RestaurantApiService.baseUrl}$postcode')))
          .thenAnswer((_) async => http.Response(jsonEncode(expectedJson), 200));

      final result = await service.fetchRestaurantsRaw(postcode);

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 2);
      expect(result[0]['name'], 'Restaurant A');
      expect(result[1]['name'], 'Restaurant B');
    });

    test('fetchRestaurantsRaw throws exception on non-200 status', () async {
      final postcode = 'INVALID';

      // Mock a bad HTTP response
      when(mockClient.get(Uri.parse('${RestaurantApiService.baseUrl}$postcode')))
          .thenAnswer((_) async => http.Response('Not found', 404));

      expect(
        () async => await service.fetchRestaurantsRaw(postcode),
        throwsA(isA<Exception>()),
      );
    });

    test('fetchRestaurantsRaw throws exception on network error', () async {
      final postcode = 'EC4M7RF';

      // Mock a network error
      when(mockClient.get(Uri.parse('${RestaurantApiService.baseUrl}$postcode')))
          .thenThrow(Exception('Network error'));

      expect(
        () async => await service.fetchRestaurantsRaw(postcode),
        throwsA(isA<Exception>()),
      );
    });
  });
}
