import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';


final Logger logger = Logger();

class UserLocationService {
  final Location _location;

  UserLocationService([Location? location]) : _location = location ?? Location();

  /* Raw proxy methods ––– NO caching / retry / business rules –––––––––– */

  Future<bool> serviceEnabled() => _location.serviceEnabled();

  Future<bool> requestService() => _location.requestService();

  Future<PermissionStatus> permissionStatus() => _location.hasPermission();

  Future<PermissionStatus> requestPermission() => _location.requestPermission();

  Future<LocationData> getLocation() async {
    try {
      return await _location.getLocation();
    } on PlatformException catch (e, s) {
      logger.e('Native error while getting location');
      rethrow;
    }
  }
}
