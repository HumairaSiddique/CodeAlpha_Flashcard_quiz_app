import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashcardProvider>(context);

    if (provider.cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz Mode"),
        ),
        body: const Center(
          child: Text(
            "No Flashcards Available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Safety check: if cards were deleted from another tab while this
    // screen was alive, currentIndex could point past the new list end.
    if (currentIndex >= provider.cards.length) {
      currentIndex = 0;
      showAnswer = false;
    }

    final card = provider.cards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Mode"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Question ${currentIndex + 1} of ${provider.cards.length}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),

                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [

                        Text(
                          showAnswer
                              ? "Answer"
                              : "Question",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          showAnswer
                              ? card.answer
                              : card.question,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Chip(
                          label:
                          Text(card.category),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  showAnswer = !showAnswer;
                });
              },
              icon: Icon(
                showAnswer
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              label: Text(
                showAnswer
                    ? "Hide Answer"
                    : "Show Answer",
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (currentIndex <
                        provider.cards.length - 1) {
                      currentIndex++;
                    } else {
                      currentIndex = 0;
                    }

                    showAnswer = false;
                  });
                },

                icon:
                const Icon(Icons.arrow_forward),

                label: const Text(
                  "Next Question",
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}