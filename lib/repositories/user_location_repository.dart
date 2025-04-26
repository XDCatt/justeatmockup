import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';

import '../services/user_location_service.dart'; 
import '../errors/location_failure.dart';     

final _log = Logger();

class UserLocationRepository {
  final UserLocationService _userLocationService;
  final lock = Lock();

  // Normal usage can use default contruction, while unit tests can pass a fake/mock service
  UserLocationRepository([UserLocationService? userLocationService])
      : _userLocationService = userLocationService ?? UserLocationService();

  // Cache the location data, this speeds up consecutive calls to 300-500 ms when the position hasn’t changed
  LocationData? _cached;

  static const _retryDelay = Duration(milliseconds: 150);

  Future<LocationData> getUserLocation({int retries = 2}) async =>
      lock.synchronized(() async {
        _log.d('Start querying user location');

        var enabled = await _serviceEnabledWithRetry(retries);
        if (!enabled) {
          _log.d('Requesting user to enable GPS');
          enabled = await _userLocationService.requestService();
        }
        if (!enabled) throw const LocationServiceDisabledFailure();

        // ---------- Permission flow ----------
        var perm = await _userLocationService.permissionStatus();
        if (perm == PermissionStatus.denied) perm = await _userLocationService.requestPermission();

        if (perm == PermissionStatus.denied) {
          throw const LocationPermissionDeniedFailure();
        }
        if (perm == PermissionStatus.deniedForever) {
          throw const LocationPermissionDeniedFailure(forever: true);
        }

        // ---------- Cached result ----------
        if (_cached != null) return _cached!;

        // ---------- Fetch fresh coordinates ----------
        final data = await _userLocationService.getLocation();
        if (data.latitude == null || data.longitude == null) {
          throw PlatformException(
            code: 'LOCATION_NULL',
            message: 'Platform returned null lat/lng',
          );
        }
        _cached = data;
        _log.d('Got location: $data');
        return data;
      });


   // For fixing the SERVICE_STATUS_ERROR only
 // This eliminates the  “status couldn’t be determined on Android 14(API 34) devices (e.g. my Samsung A55)
 // This issue occurs because Android 14 has Tighter startup timing, so when we call calls serviceEnabled() within the first few hundred ms after cold-start, 
 // the Fused-Location service might not be bound yet, so the underlying binder returns null.
 // So wrap serviceEnabled() in a retry that treats the first SERVICE_STATUS_ERROR as “service not ready” and tries again after 100-200 ms.
  Future<bool> _serviceEnabledWithRetry(int retries) async {
    for (var i = 0; i <= retries; i++) {
      try {
        return await _userLocationService.serviceEnabled();
      } on PlatformException catch (e) {
        if (e.code != 'SERVICE_STATUS_ERROR' || i == retries) rethrow;
        await Future.delayed(_retryDelay);
      }
    }
    return false;
  }
}
