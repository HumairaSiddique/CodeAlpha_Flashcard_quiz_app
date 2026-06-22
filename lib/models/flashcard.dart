import 'package:hive/hive.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 0)
class Flashcard extends HiveObject {

  @HiveField(0)
  String question;

  @HiveField(1)
  String answer;

  @HiveField(2)
  String category;

  @HiveField(3)
  bool favorite;

  Flashcard({
    required this.question,
    required this.answer,
    required this.category,
    this.favorite = false,
  });

  Flashcard copyWith({
    String? question,
    String? answer,
    String? category,
    bool? favorite,
  }) {
    return Flashcard(
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      favorite: favorite ?? this.favorite,
    );
  }
}