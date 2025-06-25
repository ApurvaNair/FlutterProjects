import 'package:flutter/material.dart';
import '../models/FlashCard.dart';

class FlashCardItem extends StatelessWidget {
  final FlashCard fc;

  const FlashCardItem({Key? key, required this.fc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title of the flashcard
            Text(
              fc.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // Content of the flashcard
            Text(
              fc.content,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12.0),

            // Due Date (if available)
            Row(
              children: [
                const Icon(Icons.access_time, size: 18.0, color: Colors.grey),
                const SizedBox(width: 4.0),
                Text(
                  "Due: ${fc.dueDate.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8.0),

            // Rating display (you can customize this part further based on your design)
            Row(
              children: [
                const Icon(Icons.star, size: 18.0, color: Colors.amber),
                const SizedBox(width: 4.0),
                Text(
                  // ignore: sdk_version_since
                  "Rating: ${fc.rating.name}",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
