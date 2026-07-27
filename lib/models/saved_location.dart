import 'location_data.dart';

class SavedLocation {
  final Location location;
  String displayName;
  final bool isCurrentLocation;

  SavedLocation({
    required this.location,
    String? displayName,
    this.isCurrentLocation = false,
  }) : displayName = displayName ?? location.name;

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'displayName': displayName,
      'isCurrentLocation': isCurrentLocation,
    };
  }

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
      location: Location.fromJson(json['location']),
      displayName: json['displayName'],
      isCurrentLocation: json['isCurrentLocation'],
    );
  }
}
