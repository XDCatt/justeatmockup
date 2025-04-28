import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:justeatmockup/repositories/restaurant_repository.dart'; // Adjust import
import 'package:justeatmockup/services/restaurant_api_service.dart';
import 'package:justeatmockup/models/restaurant.dart';

// Step 1: Generate mocks
@GenerateMocks([RestaurantApiService])
import 'restaurant_repository_test.mocks.dart';

void main() {
  group('RestaurantRepository', () {
    late MockRestaurantApiService mockService;
    late RestaurantRepository repository;

    setUp(() {
      mockService = MockRestaurantApiService();
      repository = RestaurantRepository(mockService);
    });

    test('getRestaurants returns a list of up to 10 Restaurant objects', () async {
      final postcode = 'EC4M7RF';

      // Simulate 15 restaurants in raw data
      final rawList = List.generate(
        15,
        (i) => {'name': 'Restaurant $i'},
      );

      // Mock the API call
      when(mockService.fetchRestaurantsRaw(postcode))
          .thenAnswer((_) async => rawList);

      final restaurants = await repository.getRestaurants(postcode);

      expect(restaurants, isA<List<Restaurant>>());
      expect(restaurants.length, 10);
      expect(restaurants[0].name, 'Restaurant 0');
      expect(restaurants[9].name, 'Restaurant 9');
    });

    test('getRestaurants throws if fetchRestaurantsRaw throws', () async {
      final postcode = 'INVALID';

      when(mockService.fetchRestaurantsRaw(postcode))
          .thenThrow(Exception('Network error'));

      expect(
        () async => await repository.getRestaurants(postcode),
        throwsA(isA<Exception>()),
      );
    });
  });
}
