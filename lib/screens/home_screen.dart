import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_service.dart';
import '../widgets/search_bar.dart' as search_bar;
import '../widgets/restaurant_list.dart';
import '../widgets/user_location_aware.dart';

import '../models/restaurant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiService();
  final _controller = TextEditingController();
  late Future<List<Restaurant>> _restaurantsFuture;

  @override
  void initState() {
    super.initState();
    _restaurantsFuture = _api.fetchRestaurants('SW1A1AA');
  }

  void _search() {
    final postcode = _controller.text.trim();
    if (postcode.isEmpty) return;
    setState(() => _restaurantsFuture = _api.fetchRestaurants(postcode));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Finder')),
      body: Column(
        children: [
          search_bar.SearchBar(controller: _controller, onSearch: _search),
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
              builder: (context, userLocation) => FutureBuilder(
                future: _restaurantsFuture,
                builder: (ctx, snapshot) => RestaurantList(
                  snapshot: snapshot,
                  userLocation: userLocation,
                  onRetry: _search,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
