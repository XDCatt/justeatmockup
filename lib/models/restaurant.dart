class Restaurant {
  final String name;
  final List<String> cuisines;
  final double rating;
  final String address;

  Restaurant({
    required this.name,
    required this.cuisines,
    required this.rating,
    required this.address,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    // Extract cuisines from the list of cuisine objects
    final cuisineList = (json['cuisines'] as List<dynamic>?)
        ?.map((cuisine) => cuisine['name'] as String)
        .toList() ?? [];

    return Restaurant(
      name: json['name'] ?? 'Unknown Restaurant',
      cuisines: cuisineList,
      rating: (json['rating']?['starRating'] as num?)?.toDouble() ?? 0.0,
      address: json['address']?['firstLine'] ?? 'No address available',
    );
  }
}