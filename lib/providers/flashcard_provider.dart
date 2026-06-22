import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/flashcard.dart';

class FlashcardProvider extends ChangeNotifier {
  static const String boxName = "flashcardsBox";

  Box<Flashcard>? _box;
  List<Flashcard> _cards = [];

  List<Flashcard> get cards => _cards;

  // 🔥 INIT SAFE LOAD
  Future<void> loadData() async {
    _box = Hive.isBoxOpen(boxName)
        ? Hive.box<Flashcard>(boxName)
        : await Hive.openBox<Flashcard>(boxName);

    _cards = _box!.values.toList();
    notifyListeners();
  }

  // ➕ Add Card
  Future<void> addCard(Flashcard card) async {
    await _box!.add(card);
    _cards = _box!.values.toList();
    notifyListeners();
  }

  // ❌ Delete Card
  // Uses the HiveObject's own delete() instead of deleteAt(index) so it
  // always removes the correct record even if the list order/index
  // shifts (e.g. after a search filter or another screen's update).
  Future<void> deleteCard(int index) async {
    final card = _cards[index];
    await card.delete();
    _cards = _box!.values.toList();
    notifyListeners();
  }

  // ✏️ Update Card
  // Mutates the existing HiveObject and calls save() — this avoids any
  // possible mismatch between list index and box key.
  Future<void> updateCard(int index, Flashcard updatedCard) async {
    final card = _cards[index];
    card.question = updatedCard.question;
    card.answer = updatedCard.answer;
    card.category = updatedCard.category;
    card.favorite = updatedCard.favorite;
    await card.save();
    _cards = _box!.values.toList();
    notifyListeners();
  }

  // ❤️ Favorite Toggle
  Future<void> toggleFavorite(int index) async {
    final card = _cards[index];
    card.favorite = !card.favorite;
    await card.save();
    _cards = _box!.values.toList();
    notifyListeners();
  }

  // 🔍 Search
  List<Flashcard> searchCards(String query) {
    if (query.trim().isEmpty) return _cards;

    final lowerQuery = query.toLowerCase();

    return _cards.where((card) {
      return card.question.toLowerCase().contains(lowerQuery) ||
          card.answer.toLowerCase().contains(lowerQuery) ||
          card.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // 📊 Statistics
  int get totalCards => _cards.length;

  int get favoriteCards => _cards.where((card) => card.favorite).length;

  List<String> get categories =>
      _cards.map((card) => card.category).toSet().toList();
}
