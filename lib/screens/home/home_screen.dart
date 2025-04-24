import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/api_service.dart';
import '../../widgets/search_bar.dart' as search_bar;
import 'widgets/restaurant_list.dart';
import '../../widgets/user_location_aware.dart';

import '../../models/restaurant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController postcodeController = TextEditingController();
  late Future<List<Restaurant>>? restaurantsFuture;

  @override
  void initState() {
    super.initState();
    restaurantsFuture = apiService.fetchRestaurants('SW1A1AA');
  }

  void fetchRestaurants() {
    final postcode = postcodeController.text.trim();
    if (postcode.isNotEmpty) {
      setState(() {
        restaurantsFuture = apiService.fetchRestaurants(postcode);
      });
    }
  }

  @override
  void dispose() {
    postcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Finder'),
      ),
      body: Column(
        children: [
          search_bar.SearchBar(
            controller: postcodeController, 
            onSearch: fetchRestaurants,
            labelText: 'Enter UK Postcode (e.g., EC4M7RF)',
          ),
          Expanded(
            child: UserLocationAwareWidget(
              loader: (BuildContext context) => FractionallySizedBox(
                    widthFactor: 1.0,
                    child: SizedBox(
                      height: 180,
                      child: Container(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ),
              builder: (BuildContext context, GeoPoint userLocation) {
                  return FutureBuilder<List<Restaurant>>(
                    future: restaurantsFuture,
                    builder: (context, snapshot) => RestaurantList(
                      snapshot: snapshot,
                      userLocation: userLocation,
                      onRetry: fetchRestaurants,
                    ),
                  );
              },
            )
          ),
        ],
      ),
    );
  }
}
