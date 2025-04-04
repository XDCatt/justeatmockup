import 'package:json_annotation/json_annotation.dart';
import 'package:justeatmockup/models/rating.dart';
import 'address.dart';

part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  final String name;

  @JsonKey(fromJson: _cuisinesFromJson)
  final List<String> cuisines;

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

  static List<String> _cuisinesFromJson(List<dynamic>? cuisines) {
    return cuisines?.map((cuisine) => cuisine['name'] as String).toList() ?? [];
  }

}