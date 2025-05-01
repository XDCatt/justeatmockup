import 'dart:io';
import 'package:flutter/material.dart';
import 'package:justeatmockup/models/restaurant.dart';
import 'package:justeatmockup/repositories/restaurant_repository.dart';
import 'package:justeatmockup/utils/uk_postcode_validator.dart';

enum ScreenState { idle, loading, success, empty, error }

class RestaurantSearchViewModel extends ChangeNotifier {
  final RestaurantRepository _repo;
    // Expose the controller to the UI:
  TextEditingController postcodeController = TextEditingController();
  
  RestaurantSearchViewModel(this._repo) {
    // Initialize the controller with the default postcode
    postcodeController = TextEditingController(text: postcode);
  }



  /// UI-state
  ScreenState state = ScreenState.idle;
  List<Restaurant> restaurants = [];
  bool sortByRating = false;
  String postcode = 'SW1A1AA';
  String? error;

  /// Public API -------------------------------------------------------------

  void updatePostcode(String value) => postcode = value.trim();

  Future<void> search() async {
    final postcode = postcodeController.text.trim();

    final msg = UkPostcodeValidator.validate(postcode);
    if (msg != null) {
      error = msg;
      state = ScreenState.error;
      notifyListeners();
      return;
    }

    state = ScreenState.loading;
    error = null;
    notifyListeners();

    try {
      restaurants = await _repo.getRestaurants(postcode, sortByRating: sortByRating);
      state = restaurants.isEmpty ? ScreenState.empty : ScreenState.success;
    } on SocketException {
      error = 'No internet connection.';
      state = ScreenState.error;
    } on HttpException {
      error = 'Server error. Please try again later.';
      state = ScreenState.error;
    } on FormatException {
      error = 'Received badly-formatted data from the server.';
      state = ScreenState.error;
    } catch (e) {
      error = 'Unexpected error: $e';
      state = ScreenState.error;
    }

    notifyListeners();
  }

  void toggleSort(bool value) {
    sortByRating = value;
    search();
  }

  @override
  void dispose() {
    postcodeController
      .dispose();
    super.dispose();
  }
}
