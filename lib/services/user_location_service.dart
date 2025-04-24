import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';
import '../services/location_errors.dart';

final Logger logger = Logger();

class UserLocationService {
  static final Location _loc = Location();
  static final Lock _lock = Lock();
  static LocationData? _cached;                 // optional cache

  static Future<LocationData> getUserLocation() async =>
      _lock.synchronized(() async {
    try {
      logger.d('Start querying user location');

      // 1️⃣  Service enabled?
      bool serviceEnabled = await _serviceEnabledWithRetry();
      if (!serviceEnabled) {
        logger.d('Requesting user to enable GPS');
        serviceEnabled = await _loc.requestService();
      }
      if (!serviceEnabled) throw const LocationServiceDisabledException();

      // 2️⃣  Permissions
      PermissionStatus perm = await _loc.hasPermission();
      if (perm == PermissionStatus.denied) perm = await _loc.requestPermission();

      if (perm == PermissionStatus.denied) {
        throw const PermissionDeniedException();
      }
      if (perm == PermissionStatus.deniedForever) {
        throw const PermissionDeniedException(forever: true);
      }

      // 3️⃣  Already have a fresh value?
      if (_cached != null) return _cached!;

      // 4️⃣  Get coordinates
      final data = await _loc.getLocation();
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

  static Future<bool> _serviceEnabledWithRetry({int retries = 2}) async {
    for (var i = 0; i <= retries; i++) {
      try {
        return await _loc.serviceEnabled();
      } on PlatformException catch (e) {
        if (e.code != 'SERVICE_STATUS_ERROR' || i == retries) rethrow;
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }
    return false;
  }
}
