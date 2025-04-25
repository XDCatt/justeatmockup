/// Thrown when the user refuses to turn on the location/GPS switch
class LocationServiceDisabledException implements Exception {
  const LocationServiceDisabledException();

  @override
  String toString() => 'Location service is disabled on the device.';
}

/// Thrown when the app lacks runtime permission to access location.
///
/// [forever] is `true` when the user selected
/// “Don’t ask again” / “Never ask”, meaning you must send them
/// to the system settings screen; asking again will have no effect.
class PermissionDeniedException implements Exception {
  final bool forever;
  const PermissionDeniedException({this.forever = false});

  @override
  String toString() =>
      forever ? 'Location permission permanently denied.' //
              : 'Location permission denied by user.';
}
