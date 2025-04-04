import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justeatmockup/widgets/user_location_aware.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';
import '../utils/geo_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController postcodeController = TextEditingController();
  Future<List<Restaurant>>? restaurantsFuture;

  @override
  void initState() {
    super.initState();
    // Optionally fetch with the default postcode on start
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: postcodeController,
                    decoration: const InputDecoration(
                      labelText: 'Enter UK Postcode (e.g., EC4M7RF)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => fetchRestaurants(), // Trigger on Enter
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: fetchRestaurants,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: 
              UserLocationAwareWidget(
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
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No restaurants found'));
                      }

                      final restaurants = snapshot.data!;
                      return ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            color: restaurant.rating.starRating < 4.0
                              ? const Color.fromRGBO(238, 162, 164, 0.8)
                              : (restaurant.rating.starRating < 4.5
                                ? const Color.fromARGB(255, 246, 243, 82).withOpacity(0.8)
                                :  const Color.fromARGB(255, 136, 242, 170).withOpacity(0.8)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.5, 
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                restaurant.name,
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                overflow: TextOverflow.ellipsis, // Optional: handles overflow gracefully
                                                maxLines: 3, 
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 2, left: 10, right: 2, bottom: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: restaurant.rating.starRating < 4.0
                                                  ? Colors.red
                                                  : (restaurant.rating.starRating < 4.5
                                                      ? const Color.fromARGB(255, 221, 177, 2)                                                      : Colors.green),
                                            ),
                                            Text(
                                              '${restaurant.rating.starRating} (${restaurant.rating.count} reviews)',
                                              style: const TextStyle(color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the top
                                  children: [
                                    // Left side: Logo image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        restaurant.logoUrl ?? '',
                                        fit: BoxFit.cover,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: MediaQuery.of(context).size.width * 0.4,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            height: MediaQuery.of(context).size.width * 0.4,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.error, color: Colors.red),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10), // Add spacing between image and text
                                    // Right side: Text elements in a column
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end, // Align text to the left
                                        children: [
                                          // Address
                                          Container(
                                            padding: const EdgeInsets.only(top: 2, left: 10, right: 2, bottom: 5),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.black87,
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    restaurant.address.firstLine,
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          // Cuisines
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                                            ),
                                            child: Text(
                                              'Cuisines: ${restaurant.cuisines.join(', ')}',
                                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          // Distance
                                          Container(
                                            padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[600],
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              'Distance: ${GeoUtils.calculateDistance(userLocation, restaurant.address.location.toGeoPoint()).toStringAsFixed(2)} m',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              )
          ),
        ],
      ),
    );
  }
}
