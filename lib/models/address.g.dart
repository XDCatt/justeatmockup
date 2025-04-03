// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      city: json['city'] as String,
      firstLine: json['firstLine'] as String,
      postalCode: json['postalCode'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'city': instance.city,
      'firstLine': instance.firstLine,
      'postalCode': instance.postalCode,
      'location': instance.location,
    };
