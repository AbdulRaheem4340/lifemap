class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final Map<String, dynamic> preferences;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.preferences = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'preferences': preferences,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String? ?? 'Explorer',
      photoUrl: map['photoUrl'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      preferences: (map['preferences'] as Map<String, dynamic>?) ?? {},
    );
  }

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      preferences: preferences ?? this.preferences,
    );
  }
}