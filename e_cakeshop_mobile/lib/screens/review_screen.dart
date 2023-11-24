import 'package:e_cakeshop_mobile/modals/review_dialog.dart';
import 'package:flutter/material.dart';

class Review {
  final String username;
  final String comment;
  final int stars;
  final String imageUrl;

  Review({
    required this.username,
    required this.comment,
    required this.stars,
    required this.imageUrl,
  });
}

class ReviewScreen extends StatefulWidget {
  static const String routeName = "/review";

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Review> reviews = [
    Review(
      username: 'User1',
      comment: 'Great experience!',
      stars: 5,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  void _addReview(String username, String comment, double rating) {
    setState(() {
      reviews.add(
        Review(
          username: username,
          comment: comment,
          stars: rating.toInt(),
          imageUrl: 'https://via.placeholder.com/150',
        ),
      );
    });
  }

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddReviewDialog(
          onSubmit: _addReview,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Reviews'),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(reviews[index].imageUrl),
                        ),
                        title: Text(reviews[index].username),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          reviews[index].stars,
                          (i) => const Icon(Icons.star, color: Colors.amber),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reviews[index].comment,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
        onPressed: () {
          _showReviewDialog(context);
        },
        child: const Icon(Icons.rate_review),
      ),
    );
  }
}
