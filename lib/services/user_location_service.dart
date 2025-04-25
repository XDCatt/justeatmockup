import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';


final Logger logger = Logger();

class UserLocationService {
  final Location location;

  UserLocationService([Location? location]) : location = location ?? Location();

  /* Raw proxy methods ––– NO caching / retry / business rules –––––––––– */

  Future<bool> serviceEnabled() => location.serviceEnabled();

  Future<bool> requestService() => location.requestService();

  Future<PermissionStatus> permissionStatus() => location.hasPermission();

  Future<PermissionStatus> requestPermission() => location.requestPermission();

  Future<LocationData> getLocation() async {
    try {
      return await location.getLocation();
    } on PlatformException catch (e, s) {
      logger.e('Native error while getting location');
      rethrow;
    }
  }
}
