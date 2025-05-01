/// uk_postcode_validator.dart
class UkPostcodeValidator {
  static final _regex = RegExp(
    r'^[A-Za-z]{1,2}\d[A-Za-z\d]?\s?\d[A-Za-z]{2}$',
    caseSensitive: false,
  );

  /// Returns `null` when the postcode is valid; otherwise the error string.
  static String? validate(String? value) {
    final pc = (value ?? '').trim();
    if (pc.isEmpty) return 'Please enter a postcode';

    // canonical UK PC length after stripping the space is 5-7 chars
    final noSpace = pc.replaceAll(' ', '');
    if (noSpace.length < 5 || noSpace.length > 7) {
      return 'Please enter a valid postcode';
    }
    if (!_regex.hasMatch(pc)) return 'Postcode format is invalid';

    return null; // 👍  valid
  }
}
