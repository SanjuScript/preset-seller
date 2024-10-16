import 'package:flutter/material.dart';
import 'package:seller_app/MODEL/review_data_model.dart';
import 'package:intl/intl.dart'; // For date parsing

class ReviewPage extends StatefulWidget {
  final List<ReviewModel> reviews;

  const ReviewPage({super.key, required this.reviews});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late List<ReviewModel> sortedReviews;
  String sortOption = 'date'; // Default sorting by date

  @override
  void initState() {
    super.initState();
    sortedReviews = List.from(widget.reviews); // Make a copy of the reviews
    _sortReviews();
  }

  void _sortReviews() {
    setState(() {
      if (sortedReviews.isEmpty) return; // No need to sort if there are no reviews

      if (sortOption == 'date') {
        // Sort by date (most recent first)
        sortedReviews.sort((a, b) {
          try {
            DateTime dateA = DateFormat('yyyy-MM-dd').parse(a.date);
            DateTime dateB = DateFormat('yyyy-MM-dd').parse(b.date);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0; // In case of parsing error, don't change order
          }
        });
      } else if (sortOption == 'rating') {
        // Sort by highest rating first
        sortedReviews.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (sortOption == 'weak') {
        // Sort by lowest rating first
        sortedReviews.sort((a, b) => a.rating.compareTo(b.rating));
      }
    });
  }

  void _onSortOptionSelected(String option) {
    setState(() {
      sortOption = option;
      _sortReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Reviews",
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(fontSize: size.width * .07),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onSortOptionSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'date',
                child: Text('Sort by Date'),
              ),
              const PopupMenuItem(
                value: 'rating',
                child: Text('Sort by Rating (Highest First)'),
              ),
              const PopupMenuItem(
                value: 'weak',
                child: Text('Sort by Rating (Weakest First)'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: sortedReviews.isEmpty
            ? Center(
                child: Text(
                  "No reviews yet!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              )
            : ListView.builder(
                itemCount: sortedReviews.length,
                itemBuilder: (context, index) {
                  final review = sortedReviews[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Image
                          ClipOval(
                            child: review.profilUrl.isNotEmpty
                                ? Image.network(
                                    review.profilUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person, size: 50);
                                    },
                                  )
                                : const Icon(Icons.person, size: 50),
                          ),
                          const SizedBox(width: 16),
                          // Review Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Name and Date
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      review.userName.isNotEmpty
                                          ? review.userName
                                          : "Anonymous",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      review.date.isNotEmpty
                                          ? review.date
                                          : "Unknown date",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Star Rating
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < review.rating
                                          ? Icons.favorite
                                          : Icons.favorite,
                                      color: i < review.rating
                                          ? Colors.red[400]
                                          : Colors.grey[300],
                                      size: 18,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 8),
                                // Comment
                                Text(
                                  review.comment.isNotEmpty
                                      ? review.comment
                                      : "No comment provided.",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
