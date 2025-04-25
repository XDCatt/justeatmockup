import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:justeatmockup/widgets/error_card.dart';
import '../../widgets/search_bar.dart' as search_bar;
import 'widgets/restaurant_list.dart';
import '../../widgets/user_location_aware.dart';

import '../../models/restaurant.dart';
import '../../services/restaurant_api_service.dart';
import '../../repositories/restaurant_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RestaurantRepository restaurantRepo = RestaurantRepository(RestaurantApiService());

  final TextEditingController postcodeController = TextEditingController();
  late Future<List<Restaurant>> restaurantsFuture;

  @override
  void initState() {
    super.initState();
    // Default search when the screen opens
    restaurantsFuture = restaurantRepo.getRestaurants('SW1A1AA');

  }

  Future<List<Restaurant>> safeGetRestaurants(String postcode) async {
    try {
      return await restaurantRepo.getRestaurants(postcode);
    } on HttpException {
      throw Exception('Server error. Please try again later.');
    } on SocketException {
      throw Exception('No internet connection.');
    } on FormatException {
      throw Exception('Received badly-formatted data from the server.');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String getErrorMessage(Object error) {
    if (error is SocketException) {
      return 'No internet connection, please check your connection.';
    } else if (error is HttpException) {
      return 'Server error. Please try again later.';
    } else if (error is FormatException) {
      return 'Bad data received from the server. Please try again.';
    }
    return 'Unexpected error occurred, please try again.';
  }

  void fetchRestaurants() {
    final postcode = postcodeController.text.trim();
    // SearchBar input validation
    if (postcode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a postcode')),
      );
      return;
    } else if (postcode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid postcode')),
      );
      return;
    } else if (postcode.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Postcode too long')),
      );
      return;
    } else if (postcode.length == 8 && !postcode.contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Postcode should contain a space')),
      );
      return;
    }
    else {
      setState(() {
        restaurantsFuture = safeGetRestaurants(postcode);
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
              loader: (_) => const Center(child: CircularProgressIndicator()),
              builder: (BuildContext context, GeoPoint userLocation) {
                  return FutureBuilder<List<Restaurant>>(
                    future: restaurantsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return ErrorCard(
                          onRetry: fetchRestaurants, 
                          errorMessage: getErrorMessage(snapshot.error!),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return ErrorCard(
                          onRetry: fetchRestaurants, 
                          errorMessage: 'No restaurants found. Please try again.',
                        );
                      }
        
                      return RestaurantList(
                        snapshot: snapshot,
                        userLocation: userLocation,
                        onRetry: fetchRestaurants,
                      );
                    }
                  );
              },
            )
          ),
        ],
      ),
    );
  }
}
