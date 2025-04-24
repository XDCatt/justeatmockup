import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';
import '../services/location_errors.dart';

final Logger logger = Logger();

class UserLocationService {
  static final Location location = Location();
  static final Lock lock = Lock();

  // Cache the location data, this trims 300-500 ms on subsequent calls when the position hasn’t changed
  static LocationData? _cached;              

  static Future<LocationData> getUserLocation() async =>
      lock.synchronized(() async {
    try {
      logger.d('Start querying user location');

      // Service enabled
      bool serviceEnabled = await _serviceEnabledWithRetry();

      if (!serviceEnabled) {
        logger.d('Requesting user to enable GPS');
        serviceEnabled = await location.requestService();
      }
      if (!serviceEnabled) throw const LocationServiceDisabledException();

      // Permissions
      PermissionStatus perm = await location.hasPermission();
      if (perm == PermissionStatus.denied) perm = await location.requestPermission();

      if (perm == PermissionStatus.denied) {
        throw const PermissionDeniedException();
      }
      if (perm == PermissionStatus.deniedForever) {
        throw const PermissionDeniedException(forever: true);
      }

      if (_cached != null) return _cached!;

      final data = await location.getLocation();
      if (data.latitude == null || data.longitude == null) {
        throw PlatformException(
          code: 'LOCATION_NULL',
          message: 'Platform returned null lat/lng',
        );
      }
      _cached = data;
      logger.d('Got location: $data');
      return data;
    } on PlatformException catch (e, s) {
      logger.e('Native error while getting location: '
          '(${e.code}): ${e.message}');
      rethrow;
    }
  });

 // For fixing the SERVICE_STATUS_ERROR only
 // This eliminates the  “status couldn’t be determined on Android 14(API 34) devices (e.g. my Samsung A55)
 // This issue occurs because Android 14 has Tighter startup timing, so when we call calls serviceEnabled() within the first few hundred ms after cold-start, 
 // the Fused-Location service might not be bound yet, so the underlying binder returns null.
 // So wrap serviceEnabled() in a retry that treats the first SERVICE_STATUS_ERROR as “service not ready” and tries again after 100-200 ms.
  static Future<bool> _serviceEnabledWithRetry({int retries = 2}) async {
    for (var i = 0; i <= retries; i++) {
      try {
        return await location.serviceEnabled();
      } on PlatformException catch (e) {
        if (e.code != 'SERVICE_STATUS_ERROR' || i == retries) rethrow;
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }
    return false;
  }
}
