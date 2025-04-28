import '../services/restaurant_api_service.dart';
import '../../models/restaurant.dart';

class RestaurantRepository {
  // Private API service instance, so that the UI layer can't bypass the repository and call a service directly
  final RestaurantApiService _restaurantApiService;

  RestaurantRepository(this._restaurantApiService);

  // Public API → returns [Restaurant]-typed entities, limited to 10 as per assignment requirements.
  Future<List<Restaurant>> getRestaurants(String postcode, { bool sortByRating = false, }) async {
    final rawList = await _restaurantApiService.fetchRestaurantsRaw(postcode);
    // Business rule:
    //  - order by rating
    final restaruantList = rawList.take(10).map(Restaurant.fromJson).toList(growable: false);

    if (sortByRating == true) {
      restaruantList.sort((a, b) => b.rating.starRating.compareTo(a.rating.starRating));
    }

    return restaruantList;

    // Business rule:
    //  - limit to 10
    //  - map to domain model
    return rawList
        .take(10)
        // Convert to a list of Restaurant objects, meaning only contains the data needed by the presentation of the app
        .map(Restaurant.fromJson)
        .toList(growable: false);
  }
}
