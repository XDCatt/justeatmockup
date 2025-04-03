import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  final String name;

  @JsonKey(fromJson: _cuisinesFromJson)
  final List<String> cuisines;

  @JsonKey(name: 'rating', fromJson: _ratingFromJson)
  final double rating;

  @JsonKey(name: 'address', fromJson: _addressFromJson)
  final String address;

  Restaurant({
    required this.name,
    required this.cuisines,
    required this.rating,
    required this.address,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  // Custom parsing for cuisines (extracts 'name' from each cuisine object)
  static List<String> _cuisinesFromJson(List<dynamic>? cuisines) {
    return cuisines?.map((cuisine) => cuisine['name'] as String).toList() ?? [];
  }

  // Custom parsing for rating (extracts 'starRating')
  static double _ratingFromJson(Map<String, dynamic>? rating) {
    return (rating?['starRating'] as num?)?.toDouble() ?? 0.0;
  }

  // Custom parsing for address (extracts 'firstLine')
  static String _addressFromJson(Map<String, dynamic>? address) {
    return address?['firstLine'] ?? 'No address available';
  }
}