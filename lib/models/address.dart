import 'package:json_annotation/json_annotation.dart';
import 'location.dart'; // We'll create this next

part 'address.g.dart';

@JsonSerializable()
class Address {
  final String city;
  final String firstLine;
  final String postalCode;
  final Location location;

  Address({
    required this.city,
    required this.firstLine,
    required this.postalCode,
    required this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}