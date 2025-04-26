import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justeatmockup/widgets/error_card.dart';
import 'package:location/location.dart';

import '../repositories/user_location_repository.dart';
import '../errors/location_failure.dart';

class UserLocationAwareWidget extends StatefulWidget {
  final Widget Function(BuildContext context, GeoPoint userLocation) builder;
  final Widget Function(BuildContext context)? loader;

  const UserLocationAwareWidget({
    super.key,
    required this.builder,
    this.loader,
  });

  @override
  State<StatefulWidget> createState() => _UserLocationAwareState();
}

class _UserLocationAwareState extends State<UserLocationAwareWidget> {
  final locationRepo = UserLocationRepository();  
  late Future<LocationData> future;

  @override
  void initState() {
    super.initState();
    future = locationRepo.getUserLocation();
  }

  void retry() {
    setState(() => future = locationRepo.getUserLocation());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationData>(
        future: future,
        builder: (BuildContext locationContext,
            AsyncSnapshot<LocationData> locationDataSnapshot) {
          if (locationDataSnapshot.connectionState == ConnectionState.waiting) {
            if (widget.loader == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return widget.loader!(context);
            }
          }

        if (locationDataSnapshot.hasError) {
          final err = locationDataSnapshot.error;
          String message;
          if (err is LocationServiceDisabledFailure ||
              err is LocationPermissionDeniedFailure) {
            message = err.toString();
          } else {
            message = 'Unexpected error occurred, please try again.';
          }

          return ErrorCard(
            onRetry: retry,
            errorMessage: message,
          );
        }

        final location = locationDataSnapshot.requireData;
        final longitude = location.longitude;
        final latitude  = location.latitude;

        if (longitude == null || latitude == null) {
          throw Exception('User latitude/longitude is null');
        }

        final GeoPoint userLocation = GeoPoint(latitude, longitude);

        return widget.builder(context, userLocation);
      });
  }
}
