import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:justeatmockup/screens/home/restaurant_search_view_model.dart';
import 'package:justeatmockup/utils/uk_postcode_validator.dart';
import 'package:justeatmockup/widgets/error_card.dart';
import '../../widgets/search_bar.dart' as search_bar;
import 'widgets/restaurant_list.dart';
import '../../widgets/user_location_aware.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RestaurantSearchViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Finder'),
        actions: [
          Switch(
            value: vm.sortByRating,
            onChanged: vm.toggleSort,
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: 
              search_bar.SearchBar(
                onSearch: vm.search,
                controller: vm.postcodeController,
                labelText: 'Enter UK Postcode (e.g., EC4M7RF)',
                validator: UkPostcodeValidator.validate,
              )
          ),
          Expanded(child: _buildBody(vm)),
        ],
      ),
    );
  }

  Widget _buildBody(RestaurantSearchViewModel vm) {
    switch (vm.state) {
      case ScreenState.loading:
        return const Center(child: CircularProgressIndicator());
      case ScreenState.error:
        return ErrorCard(onRetry: vm.search, errorMessage: vm.error ?? '');
      case ScreenState.empty:
        return ErrorCard(onRetry: vm.search, errorMessage: 'No restaurants found.');
      case ScreenState.success:
        return UserLocationAwareWidget(
          loader: (_) => const Center(child: CircularProgressIndicator()),
          builder: (_, userLoc) => RestaurantList(
            restaurants: vm.restaurants,
            userLocation: userLoc,      // 👈 now available inside the list
            onRetry: vm.search,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

