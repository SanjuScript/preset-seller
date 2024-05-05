class AdminProfile {
  final String? firstName;
  final String? uid;
  final String? lastName;
  final String? email;
  final String? userProfileUrl;
  final String? description;
  final String? instagram;
  final int? earned;
  final int? likes;

  AdminProfile(
      {this.firstName,
      this.uid,
      this.lastName,
      this.email,
      this.userProfileUrl,
      this.description,
      this.likes ,
      this.earned,
      this.instagram});

  factory AdminProfile.fromMap(Map<String, dynamic> map) {
    return AdminProfile(
      firstName: map['firstname'] ?? '',
      uid: map['uid'] ?? '',
      lastName: map['lastname'] ?? '',
      earned: map['earned'],
      likes: map['likes'],
      email: map['email'] ?? '',
      userProfileUrl: map['profile_picture'] ?? '',
      description: map['description'] ?? '',
      instagram: map['instagram'] ?? '',
    );
  }
}
