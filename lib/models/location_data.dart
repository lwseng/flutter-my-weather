class Location {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String state;
  final String timezone;

  Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.state,
    required this.timezone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'state': state,
      'timezone': timezone,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      country: json['country'],
      state: json['state'],
      timezone: json['timezone'],
    );
  }
}
