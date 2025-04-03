// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      count: (json['count'] as num).toInt(),
      starRating: (json['starRating'] as num).toDouble(),
      userRating: (json['userRating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'count': instance.count,
      'starRating': instance.starRating,
      'userRating': instance.userRating,
    };
