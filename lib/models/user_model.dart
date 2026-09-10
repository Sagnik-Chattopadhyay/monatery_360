enum UserRole { tourist, local }

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final String? monasteryAffiliation; // For locals (e.g., Rumtek Monastery)
  final int visitedCount;
  final int toursCompleted;
  final int badgesCount;
  final DateTime createdAt;

  // Health Profile Fields (High Altitude Safety)
  final bool hasAsthma;
  final bool hasHeartCondition;
  final bool hasAltitudeSensitivity;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.monasteryAffiliation,
    this.visitedCount = 0,
    this.toursCompleted = 0,
    this.badgesCount = 0,
    required this.createdAt,
    this.hasAsthma = false,
    this.hasHeartCondition = false,
    this.hasAltitudeSensitivity = false,
  });

  bool get isLocal => role == UserRole.local;
  bool get isTourist => role == UserRole.tourist;
  bool get hasHealthRisk => hasAsthma || hasHeartCondition || hasAltitudeSensitivity;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'monasteryAffiliation': monasteryAffiliation,
      'visitedCount': visitedCount,
      'toursCompleted': toursCompleted,
      'badgesCount': badgesCount,
      'createdAt': createdAt.toIso8601String(),
      'hasAsthma': hasAsthma,
      'hasHeartCondition': hasHeartCondition,
      'hasAltitudeSensitivity': hasAltitudeSensitivity,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'Monastery Traveler',
      role: map['role'] == 'local' ? UserRole.local : UserRole.tourist,
      monasteryAffiliation: map['monasteryAffiliation'],
      visitedCount: map['visitedCount'] ?? 0,
      toursCompleted: map['toursCompleted'] ?? 0,
      badgesCount: map['badgesCount'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      hasAsthma: map['hasAsthma'] ?? false,
      hasHeartCondition: map['hasHeartCondition'] ?? false,
      hasAltitudeSensitivity: map['hasAltitudeSensitivity'] ?? false,
    );
  }
}
