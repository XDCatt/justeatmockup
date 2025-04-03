// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      name: json['name'] as String,
      cuisines: Restaurant._cuisinesFromJson(json['cuisines'] as List?),
      rating:
          Restaurant._ratingFromJson(json['rating'] as Map<String, dynamic>?),
      address:
          Restaurant._addressFromJson(json['address'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cuisines': instance.cuisines,
      'rating': instance.rating,
      'address': instance.address,
    };
