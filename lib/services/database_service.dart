import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard.dart';

class DatabaseService {
  static const String flashcardBox = 'flashcardsBox';


  Future<void> initializeDatabase() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(FlashcardAdapter().typeId)) {
      Hive.registerAdapter(FlashcardAdapter());
    }

    if (!Hive.isBoxOpen(flashcardBox)) {
      await Hive.openBox<Flashcard>(flashcardBox);
    }
  }

  Box<Flashcard> getFlashcardBox() {
    return Hive.box<Flashcard>(flashcardBox);
  }

  Future<void> clearDatabase() async {
    await Hive.box<Flashcard>(flashcardBox).clear();
  }

  Future<void> closeDatabase() async {
    await Hive.close();
  }
}
