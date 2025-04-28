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

  bool _sortByRating = false;

  @override
  void initState() {
    super.initState();
    // Default search when the screen opens
    restaurantsFuture = restaurantRepo.getRestaurants('SW1A1AA', sortByRating: false);

  }

  Future<List<Restaurant>> safeGetRestaurants(String postcode, {bool sortByRating = false}) async {
    try {
      return await restaurantRepo.getRestaurants(postcode, sortByRating: sortByRating);
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
    if (error is SocketException || error is HttpException || error is FormatException) {
      return error.toString();
    } 
    else{
      return 'Unexpected error occurred, please try again.';
    }
  }

  void fetchRestaurants({bool sortByRating = false}) {
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
        restaurantsFuture = safeGetRestaurants(postcode, sortByRating: sortByRating);
      });
    }
  }

  void _onSwitchChanged(bool toggleValue) {
    setState(() {
      _sortByRating = toggleValue;
      restaurantsFuture = restaurantRepo.getRestaurants(postcodeController.text.trim().isEmpty 
        ? 'SW1A1AA' 
        : postcodeController.text.trim(),
        sortByRating: _sortByRating
      );
    });
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: 
              Switch(
                  value: _sortByRating, 
                  onChanged: _onSwitchChanged,
                  activeColor:  Colors.orange.withOpacity(0.8),
                  activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  thumbColor: MaterialStateProperty.all<Color>(
                    Colors.white /* Icons */,
                  ),
                  trackColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF929189)/* Icons */,
                  ),
              ),   
          )
        ],
      ),
      body: Column(
        children: [
          search_bar.SearchBar(
            controller: postcodeController, 
            onSearch: () => fetchRestaurants(sortByRating: _sortByRating),
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
                          onRetry: () => fetchRestaurants(sortByRating: _sortByRating), 
                          errorMessage: getErrorMessage(snapshot.error!),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return ErrorCard(
                          onRetry: () => fetchRestaurants(sortByRating: _sortByRating), 
                          errorMessage: 'No restaurants found. Please try again.',
                        );
                      }
        
                      return RestaurantList(
                        snapshot: snapshot,
                        userLocation: userLocation,
                        onRetry: () => fetchRestaurants(sortByRating: _sortByRating),
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
