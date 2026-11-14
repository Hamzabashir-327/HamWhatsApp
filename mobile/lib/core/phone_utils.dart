import 'countries.dart';

/// Country code (like +92) of a full number such as +923327159336.
String countryCodeOf(String fullNumber) {
  final codes = kCountries.map((c) => c.code).toSet().toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  for (final code in codes) {
    if (fullNumber.startsWith(code)) return code;
  }
  return kCountries.first.code;
}

/// Turns a number from the address book into +<country><number>.
String? normalizePhone(String raw, String defaultCode) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 7) return null;
  String result;
  if (raw.trim().startsWith('+')) {
    result = '+$digits';
  } else if (digits.startsWith('00')) {
    result = '+${digits.substring(2)}';
  } else if (digits.startsWith('0')) {
    result = '$defaultCode${digits.replaceFirst(RegExp(r'^0+'), '')}';
  } else {
    final cc = defaultCode.substring(1);
    result = digits.startsWith(cc) && digits.length > cc.length + 6
        ? '+$digits'
        : '$defaultCode$digits';
  }
  final n = result.length - 1;
  return n >= 8 && n <= 15 ? result : null;
}
