import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_flashcard_screen.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/flashcard_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    FlashcardProvider provider,
    int index,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Flashcard"),
        content: const Text(
          "Are you sure you want to delete this flashcard? This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.deleteCard(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FlashLearn Pro",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          final displayedCards = provider.searchCards(_query);

          return Column(
            children: [
              // ===== TOP CARD =====
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Flashcards",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.totalCards.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.school,
                      size: 55,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              // ===== SEARCH BAR =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: "Search flashcards...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ===== LIST =====
              Expanded(
                child: displayedCards.isEmpty
                    ? Center(
                        child: Text(
                          provider.cards.isEmpty
                              ? "No Flashcards Yet"
                              : "No matches found",
                          style: const TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: displayedCards.length,
                        itemBuilder: (context, i) {
                          final card = displayedCards[i];
                          // Find the card's real position in the unfiltered
                          // list so favorite/edit/delete act on the right item.
                          final realIndex = provider.cards.indexOf(card);

                          return FlashcardTile(
                            card: card,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddFlashcardScreen(
                                    flashcard: card,
                                    index: realIndex,
                                  ),
                                ),
                              );
                            },
                            onFavorite: () =>
                                provider.toggleFavorite(realIndex),
                            onDelete: () =>
                                _confirmDelete(context, provider, realIndex),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddFlashcardScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
