import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/restaurant.dart';
import 'restaurant_card.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({
    super.key,
    required this.restaurants,
    required this.userLocation,
    required this.onRetry,
  });

  final List<Restaurant> restaurants;
  final GeoPoint userLocation;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    //final restaurants = snapshot.data!;
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) => RestaurantCard(
        restaurant: restaurants[index],
        userLocation: userLocation,
      ),
    );
  }
}
