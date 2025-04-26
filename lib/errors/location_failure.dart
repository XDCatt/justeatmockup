import 'failure.dart';

class LocationFailure extends Failure {
  const LocationFailure(super.message);

  const factory LocationFailure.serviceDisabled() =
      LocationServiceDisabledFailure;
  const factory LocationFailure.permissionDenied({bool forever}) =
      LocationPermissionDeniedFailure;
}

// Thrown when the user refuses to turn on the location/GPS switch

final class LocationServiceDisabledFailure extends LocationFailure {
  const LocationServiceDisabledFailure() : super('Location services are disabled.\n'
                'Please turn them on and retry.');
}

// Thrown when the app lacks runtime permission to access location. [forever] is `true` when the user selected
final class LocationPermissionDeniedFailure extends LocationFailure {
  const LocationPermissionDeniedFailure({this.forever = false})
      : super(forever
            ? 'Permission permanently denied.'
            : 'Location permission denied.\n'
                'Grant permission and retry.');
  final bool forever;

  @override
  String toString() =>
      'LocationPermissionDeniedFailure(forever: $forever): $message';
}





