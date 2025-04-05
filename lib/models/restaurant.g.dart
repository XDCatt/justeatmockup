// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      name: json['name'] as String,
      cuisines: Restaurant._cuisinesFromJson(json['cuisines'] as List?),
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      logoUrl: json['logoUrl'] as String?,
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cuisines': instance.cuisines,
      'rating': instance.rating.toJson(),
      'address': instance.address.toJson(),
      'logoUrl': instance.logoUrl,
    };
