class AdminProfile {
  final String? firstName;
  final String? uid;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? userProfileUrl;
  final String? description;
  final String? instagram;

  AdminProfile(
      {this.firstName,
      this.uid,
      this.lastName,
      this.email,
      this.phone,
      this.userProfileUrl,
      this.description,
      this.instagram});

  factory AdminProfile.fromMap(Map<String, dynamic> map) {
    return AdminProfile(
      firstName: map['firstname'] ?? '',
      uid: map['uid'] ?? '',
      lastName: map['lastname'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userProfileUrl: map['profile_picture'] ?? '',
      description: map['description'] ?? '',
      instagram: map['instagram'] ?? '',
    );
  }
}
