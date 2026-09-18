class Horoscope {
  final String? id;
  final DateTime? dateOfBirth;
  final String timeOfBirth;
  final String placeOfBirth;
  final double? latitude;
  final double? longitude;
  final int? timeZoneOffsetMinutes;
  final String? sunSign;
  final String? calculatedMoonSign;
  final String moonSignPrecision;
  final String? moonSign;
  final String? nakshatra;
  final Map<String, dynamic>? vedicChart;

  const Horoscope({
    this.id,
    this.dateOfBirth,
    this.timeOfBirth = '',
    this.placeOfBirth = '',
    this.latitude,
    this.longitude,
    this.timeZoneOffsetMinutes,
    this.sunSign,
    this.calculatedMoonSign,
    this.moonSignPrecision = 'unavailable',
    this.moonSign,
    this.nakshatra,
    this.vedicChart,
  });

  bool get hasChart =>
      sunSign != null || calculatedMoonSign != null || nakshatra != null;

  Map<String, dynamic> toCreateJson() => {
    'dateOfBirth': dateOfBirth != null ? _shortDate(dateOfBirth!) : null,
    'timeOfBirth': timeOfBirth.isEmpty ? null : timeOfBirth,
    'placeOfBirth': placeOfBirth.isEmpty ? null : placeOfBirth,
    'timeZoneOffsetMinutes': timeZoneOffsetMinutes,
  };

  static String _shortDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  factory Horoscope.fromJson(Map<String, dynamic> json) {
    return Horoscope(
      id: (json['id'] ?? json['_id'])?.toString(),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null,
      timeOfBirth: json['timeOfBirth']?.toString() ?? '',
      placeOfBirth: json['placeOfBirth']?.toString() ?? '',
      latitude: json['latitude'] is num
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : null,
      timeZoneOffsetMinutes: json['timeZoneOffsetMinutes'] is num
          ? (json['timeZoneOffsetMinutes'] as num).toInt()
          : null,
      sunSign: json['sunSign']?.toString(),
      calculatedMoonSign: json['calculatedMoonSign']?.toString(),
      moonSignPrecision: json['moonSignPrecision']?.toString() ?? 'unavailable',
      moonSign: json['moonSign']?.toString(),
      nakshatra: json['nakshatra']?.toString(),
      vedicChart: json['vedicChart'] is Map
          ? Map<String, dynamic>.from(json['vedicChart'] as Map)
          : null,
    );
  }
}
