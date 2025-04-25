import '../services/restaurant_api_service.dart';
import '../../models/restaurant.dart';

class RestaurantRepository {
  final RestaurantApiService remote;

  RestaurantRepository(this.remote);

  // Public API → returns fully-typed [Restaurant] entities, limited to 10 as per assignment requirements.
  Future<List<Restaurant>> getRestaurants(String postcode) async {
    final rawList = await remote.fetchRestaurantsRaw(postcode);

    // Business rule lives here:
    //  - limit to 10
    //  - map to domain model
    return rawList
        .take(10)
        .map(Restaurant.fromJson)
        .toList(growable: false);
  }
}
