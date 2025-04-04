import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class GeoUtils {
  static const double EARTH_MEAN_RADIUS = 6371.009 * 1000;

  static double calculateDistance(GeoPoint p1, GeoPoint p2) {
    final pi1 = p1.latitude * pi / 180;
    final pi2 = p2.latitude * pi / 180;
    final deltaPi = (p2.latitude - p1.latitude) * pi / 180;
    final deltaLambda = (p2.longitude - p1.longitude) * pi / 180;

    final a = pow(sin(deltaPi / 2), 2) +
        cos(pi1) * cos(pi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return EARTH_MEAN_RADIUS * c;
  }
}
