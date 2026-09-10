class TourismServiceModel {
  final String id;
  final String title;
  final String serviceType; // 'Transport / Shared Cab', 'Private Jeep', 'Local Heritage Guide', 'Homestay / Monastery Stay'
  final String providerName;
  final String phoneContact;
  final String location;
  final String pricing;
  final double rating;
  final String imageUrl;
  final List<String> coveredMonasteries;

  TourismServiceModel({
    required this.id,
    required this.title,
    required this.serviceType,
    required this.providerName,
    required this.phoneContact,
    required this.location,
    required this.pricing,
    this.rating = 4.8,
    required this.imageUrl,
    this.coveredMonasteries = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'serviceType': serviceType,
      'providerName': providerName,
      'phoneContact': phoneContact,
      'location': location,
      'pricing': pricing,
      'rating': rating,
      'imageUrl': imageUrl,
      'coveredMonasteries': coveredMonasteries,
    };
  }

  factory TourismServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return TourismServiceModel(
      id: id,
      title: map['title'] ?? '',
      serviceType: map['serviceType'] ?? 'Transport',
      providerName: map['providerName'] ?? '',
      phoneContact: map['phoneContact'] ?? '',
      location: map['location'] ?? '',
      pricing: map['pricing'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      imageUrl: map['imageUrl'] ?? '',
      coveredMonasteries: List<String>.from(map['coveredMonasteries'] ?? []),
    );
  }
}
