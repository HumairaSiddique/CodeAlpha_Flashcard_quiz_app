import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Statistics"),
            centerTitle: true,
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                // Total Cards
                Card(
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(
                      Icons.menu_book,
                      color: Colors.indigo,
                    ),
                    title: const Text("Total Cards"),
                    trailing: Text(
                      provider.totalCards.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Favorites
                Card(
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    title: const Text("Favorite Cards"),
                    trailing: Text(
                      provider.favoriteCards.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Categories
                Card(
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(
                      Icons.category,
                      color: Colors.green,
                    ),
                    title: const Text("Categories"),
                    trailing: Text(
                      provider.categories.length.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [

                      const Icon(
                        Icons.analytics,
                        size: 50,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${provider.totalCards}",
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const Text(
                        "Total Flashcards Created",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}