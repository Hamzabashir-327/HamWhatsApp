class Country {
  const Country(this.flag, this.name, this.code, this.minDigits, this.maxDigits);

  final String flag;
  final String name;
  final String code;
  final int minDigits;
  final int maxDigits;
}

const List<Country> kCountries = [
  Country('🇵🇰', 'Pakistan', '+92', 10, 10),
  Country('🇮🇳', 'India', '+91', 10, 10),
  Country('🇧🇩', 'Bangladesh', '+880', 10, 10),
  Country('🇦🇪', 'United Arab Emirates', '+971', 8, 9),
  Country('🇸🇦', 'Saudi Arabia', '+966', 9, 9),
  Country('🇶🇦', 'Qatar', '+974', 8, 8),
  Country('🇴🇲', 'Oman', '+968', 8, 8),
  Country('🇰🇼', 'Kuwait', '+965', 8, 8),
  Country('🇬🇧', 'United Kingdom', '+44', 10, 10),
  Country('🇺🇸', 'United States', '+1', 10, 10),
  Country('🇨🇦', 'Canada', '+1', 10, 10),
  Country('🇦🇺', 'Australia', '+61', 9, 9),
  Country('🇩🇪', 'Germany', '+49', 10, 11),
  Country('🇫🇷', 'France', '+33', 9, 9),
  Country('🇹🇷', 'Turkey', '+90', 10, 10),
  Country('🇨🇳', 'China', '+86', 11, 11),
  Country('🇦🇫', 'Afghanistan', '+93', 9, 9),
  Country('🇪🇬', 'Egypt', '+20', 10, 10),
  Country('🇳🇬', 'Nigeria', '+234', 10, 10),
  Country('🇲🇾', 'Malaysia', '+60', 9, 10),
];
