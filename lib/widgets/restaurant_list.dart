import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';
import 'restaurant_card.dart';
import 'error_card.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({
    super.key,
    required this.snapshot,
    required this.userLocation,
    required this.onRetry,
  });

  final AsyncSnapshot<List<Restaurant>> snapshot;
  final GeoPoint userLocation;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return ErrorCard(onRetry: onRetry);
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No restaurants found'));
    }

    final restaurants = snapshot.data!;
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) => RestaurantCard(
        restaurant: restaurants[index],
        userLocation: userLocation,
      ),
    );
  }
}
