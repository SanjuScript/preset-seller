class ReviewModel {
  final String userName;
  final int rating;
  final String comment;
  final String date;
  final String profilUrl;

  ReviewModel(
      {required this.userName,
      required this.rating,
      required this.comment,
      required this.date,
      required this.profilUrl});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userName: json['userName'],
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
      profilUrl: json['profilUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date,
      'profilUrl': profilUrl,
    };
  }
}
