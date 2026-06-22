import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/flashcard.dart';
import '../providers/flashcard_provider.dart';

class AddFlashcardScreen extends StatefulWidget {
  final Flashcard? flashcard;
  final int? index;

  const AddFlashcardScreen({
    super.key,
    this.flashcard,
    this.index,
  });

  @override
  State<AddFlashcardScreen> createState() =>
      _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController questionController;
  late TextEditingController answerController;

  String selectedCategory = "Programming";
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    questionController = TextEditingController(
      text: widget.flashcard?.question ?? "",
    );

    answerController = TextEditingController(
      text: widget.flashcard?.answer ?? "",
    );

    if (widget.flashcard != null) {
      selectedCategory = widget.flashcard!.category;
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  Future<void> saveFlashcard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final provider = Provider.of<FlashcardProvider>(
      context,
      listen: false,
    );

    final card = Flashcard(
      question: questionController.text.trim(),
      answer: answerController.text.trim(),
      category: selectedCategory,
      favorite: widget.flashcard?.favorite ?? false,
    );

    if (widget.flashcard == null) {
      await provider.addCard(card);
    } else {
      await provider.updateCard(widget.index!, card);
    }

    if (!mounted) return;

    setState(() => isSaving = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final isEditing = widget.flashcard != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Flashcard" : "Add Flashcard",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Text(
                "Question",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: questionController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a question";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Enter question",
                  prefixIcon: const Icon(Icons.help),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Answer",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: answerController,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter an answer";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Enter answer",
                  prefixIcon: const Icon(Icons.lightbulb),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Programming",
                    child: Text("Programming"),
                  ),
                  DropdownMenuItem(
                    value: "Science",
                    child: Text("Science"),
                  ),
                  DropdownMenuItem(
                    value: "English",
                    child: Text("English"),
                  ),
                  DropdownMenuItem(
                    value: "General Knowledge",
                    child: Text("General Knowledge"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isSaving ? null : saveFlashcard,

                  icon: isSaving
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Icon(
                    isEditing ? Icons.edit : Icons.save,
                  ),

                  label: Text(
                    isEditing
                        ? "Update Flashcard"
                        : "Save Flashcard",
                  ),

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}