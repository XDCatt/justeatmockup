import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';

final Logger logger = Logger();

class UserLocationService {
  static final Location loc = Location();
  static Lock lock = Lock();

  static Future<LocationData> getUserLocation() async {
    return lock.synchronized(() async {
      bool serviceEnabled = await loc.serviceEnabled();
      logger.d('Start querying user location');

      if (!serviceEnabled) {
        logger.d('Location service is not enabled, requesting service');
        loc.requestService();
      }
      if (!serviceEnabled) {
        throw Exception("Cannot enabled location service");
      }

      PermissionStatus permissionGranted = await loc.hasPermission();

      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await loc.requestPermission();
      }

      switch (permissionGranted) {
        case PermissionStatus.granted:
        case PermissionStatus.grantedLimited:
          logger.d('Granted location permission');
          final LocationData locationData = await loc.getLocation();
          logger.d('Got result: user location is $locationData');
          return locationData;
        case PermissionStatus.denied:
        case PermissionStatus.deniedForever:
          logger.e('Permission for location is denied');
          throw Exception('Location permission is denied');
      }
    });
  }
}
