import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justeatmockup/widgets/error_card.dart';
import 'package:location/location.dart';
import '../services/user_location_service.dart';
import '../services/location_errors.dart';

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
  late Future<LocationData> future;

  @override
  void initState() {
    super.initState();
    future = UserLocationService.getUserLocation();
  }

  void retry() {
    setState(() => future = UserLocationService.getUserLocation());
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
          if (err is LocationServiceDisabledException) {
            message = 'Location services are disabled.\n'
                'Please turn them on and retry.';
          } else if (err is PermissionDeniedException && !err.forever) {
            message = 'Location permission denied.\n'
                'Grant permission and retry.';
          } else if (err is PermissionDeniedException && err.forever) {
            message = 'Location permission permanently denied.\n'
                'You must enable it in system settings.';
          } else {
            message = 'Unexpected error: $err';
          }

          return ErrorCard(
            onRetry: retry,
            errorMessage: message,
          );
        }

          final double? longitude = locationDataSnapshot.requireData.longitude;
          final double? latitude = locationDataSnapshot.requireData.latitude;
          if (longitude == null) {
            throw Exception('User longitude is null');
          }
          if (latitude == null) {
            throw Exception('User latitude is null');
          }

          final GeoPoint userLocation = GeoPoint(latitude, longitude);

          return widget.builder(context, userLocation);
        });
  }
}
