import 'package:logger/logger.dart';

import '../services/restaurant_api_service.dart';
import '../../models/restaurant.dart';

class RestaurantRepository {
  // Private API service instance, so that the UI layer can't bypass the repository and call a service directly
  final RestaurantApiService _restaurantApiService;
  final Logger _logger;

  RestaurantRepository(this._restaurantApiService, {Logger? logger})
      : _logger = logger ?? Logger();

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
  }
}
