import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class FlashcardTile extends StatelessWidget {
  final Flashcard card;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;

  const FlashcardTile({
    super.key,
    required this.card,
    this.onTap,
    this.onFavorite,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        onTap: onTap,

        leading: const Icon(
          Icons.school,
          color: Colors.indigo,
        ),

        title: Text(
          card.question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(card.answer),
            const SizedBox(height: 8),

            Chip(
              label: Text(card.category),
              backgroundColor: Colors.grey.shade200,
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ❤️ Favorite
            IconButton(
              icon: Icon(
                card.favorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: onFavorite,
            ),

            // ❌ Delete
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}