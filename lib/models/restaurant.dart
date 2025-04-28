import 'package:json_annotation/json_annotation.dart';
import 'package:justeatmockup/models/rating.dart';
import 'address.dart';

part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  final String name;

  @JsonKey(fromJson: _cuisinesFromJson)
  final List<String> cuisines;

  // Nested object, so we need to use the generated code to serialize/deserialize
  final Rating rating;

  final Address address;

  final String? logoUrl;

  Restaurant({
    required this.name,
    required this.cuisines,
    required this.rating,
    required this.address,
    required this.logoUrl,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  // We only need the name of the cuisine, the length of shown cuisines can be directly handled at the View
  static List<String> _cuisinesFromJson(List<dynamic>? cuisines) {
    return cuisines?.map((cuisine) => cuisine['name'] as String).toList() ?? [];
  }

}