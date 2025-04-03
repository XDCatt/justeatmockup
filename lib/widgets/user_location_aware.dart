import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../services/user_location_service.dart';

class UserLocationAwareWidget extends StatefulWidget {
  final Widget Function(BuildContext context, GeoPoint userLocation) builder;
  final Widget Function(BuildContext context)? loader;

  const UserLocationAwareWidget(
      {super.key, required this.builder, this.loader});

  @override
  State<StatefulWidget> createState() => _UserLocationAwareState();
}

class _UserLocationAwareState extends State<UserLocationAwareWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserLocationService.getUserLocation(),
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
            return Center(
              child: Text('Error: ${locationDataSnapshot.error}'),
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
