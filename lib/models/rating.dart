import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable(explicitToJson: true)
class Rating {
  final int count;
  final double starRating;
  @JsonKey(defaultValue: null)
  final double? userRating;

  Rating({
    required this.count,
    required this.starRating,
    this.userRating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}