class EventModel {
  final String id;
  final String title;
  final String monasteryId;
  final String monasteryName;
  final String createdByUid;
  final String createdByName;
  final DateTime eventDate;
  final String timeString;
  final String category; // e.g., 'Ritual', 'Festival', 'Monastic Dance', 'Meditation'
  final String description;
  final String bannerImageUrl;
  final int totalSeats;
  final int bookedSeats;
  final double entryFee; // 0 for free cultural ritual
  final List<String> rsvpedUserIds;

  EventModel({
    required this.id,
    required this.title,
    required this.monasteryId,
    required this.monasteryName,
    required this.createdByUid,
    required this.createdByName,
    required this.eventDate,
    required this.timeString,
    required this.category,
    required this.description,
    required this.bannerImageUrl,
    required this.totalSeats,
    this.bookedSeats = 0,
    this.entryFee = 0.0,
    this.rsvpedUserIds = const [],
  });

  bool get isFull => bookedSeats >= totalSeats;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'monasteryId': monasteryId,
      'monasteryName': monasteryName,
      'createdByUid': createdByUid,
      'createdByName': createdByName,
      'eventDate': eventDate.toIso8601String(),
      'timeString': timeString,
      'category': category,
      'description': description,
      'bannerImageUrl': bannerImageUrl,
      'totalSeats': totalSeats,
      'bookedSeats': bookedSeats,
      'entryFee': entryFee,
      'rsvpedUserIds': rsvpedUserIds,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map, String id) {
    return EventModel(
      id: id,
      title: map['title'] ?? '',
      monasteryId: map['monasteryId'] ?? '',
      monasteryName: map['monasteryName'] ?? 'Sikkim Monastery',
      createdByUid: map['createdByUid'] ?? '',
      createdByName: map['createdByName'] ?? 'Local Host',
      eventDate: map['eventDate'] != null
          ? DateTime.parse(map['eventDate'])
          : DateTime.now().add(const Duration(days: 3)),
      timeString: map['timeString'] ?? '09:00 AM',
      category: map['category'] ?? 'Festival',
      description: map['description'] ?? '',
      bannerImageUrl: map['bannerImageUrl'] ?? '',
      totalSeats: map['totalSeats'] ?? 50,
      bookedSeats: map['bookedSeats'] ?? 0,
      entryFee: (map['entryFee'] as num?)?.toDouble() ?? 0.0,
      rsvpedUserIds: List<String>.from(map['rsvpedUserIds'] ?? []),
    );
  }
}
