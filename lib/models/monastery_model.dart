class MonasteryModel {
  final String id;
  final String name;
  final String locationName;
  final double latitude;
  final double longitude;
  final int establishedYear;
  final String era; // e.g., '17th Century', '18th Century', 'Modern'
  final String orderSect; // e.g., 'Nyingma Order', 'Kagyu Order', 'Gelug Order'
  final String description;
  final String imageUrl;
  final List<String> panoramaUrls;
  final int archivesCount;
  final bool isFeatured;
  final String altitude;
  final List<String> nearbyAttractions;

  MonasteryModel({
    required this.id,
    required this.name,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.establishedYear,
    required this.era,
    required this.orderSect,
    required this.description,
    required this.imageUrl,
    required this.panoramaUrls,
    this.archivesCount = 0,
    this.isFeatured = false,
    this.altitude = '1,500m',
    this.nearbyAttractions = const [],
  });

  int get altitudeMeters {
    final cleaned = altitude.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 1500;
  }

  bool get isHighAltitude => altitudeMeters >= 1700;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'establishedYear': establishedYear,
      'era': era,
      'orderSect': orderSect,
      'description': description,
      'imageUrl': imageUrl,
      'panoramaUrls': panoramaUrls,
      'archivesCount': archivesCount,
      'isFeatured': isFeatured,
      'altitude': altitude,
      'nearbyAttractions': nearbyAttractions,
    };
  }

  factory MonasteryModel.fromMap(Map<String, dynamic> map, String id) {
    return MonasteryModel(
      id: id,
      name: map['name'] ?? '',
      locationName: map['locationName'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 27.33,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 88.61,
      establishedYear: map['establishedYear'] ?? 1900,
      era: map['era'] ?? 'Historic',
      orderSect: map['orderSect'] ?? 'Buddhist Order',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      panoramaUrls: List<String>.from(map['panoramaUrls'] ?? []),
      archivesCount: map['archivesCount'] ?? 0,
      isFeatured: map['isFeatured'] ?? false,
      altitude: map['altitude'] ?? '1,500m',
      nearbyAttractions: List<String>.from(map['nearbyAttractions'] ?? []),
    );
  }
}
