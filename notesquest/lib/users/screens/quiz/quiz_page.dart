import 'package:flutter/material.dart';
import 'result_quiz.dart';

class QuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const QuizPage({
    super.key,
    required this.questions,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  int score = 0;

  String selectedOptionKey = "";
  bool answered = false;

  void selectAnswer(String optionKey) {
    if (answered) return;

    setState(() {
      selectedOptionKey = optionKey;
      answered = true;

      // ================= FIXED LOGIC =================
      String correctAnswer = widget.questions[currentIndex]['answer']
          .toString()
          .trim()
          .toLowerCase();

      String selectedAnswer = widget.questions[currentIndex]['options']
          [optionKey]
          .toString()
          .trim()
          .toLowerCase();

      if (selectedAnswer == correctAnswer) {
        score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      currentIndex++;
      selectedOptionKey = "";
      answered = false;
    });
  }

  void submitQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultQuizPage(
          score: score,
          total: widget.questions.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];

    bool isLast = currentIndex == widget.questions.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: Text(
          "Question ${currentIndex + 1}/${widget.questions.length}",
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ================= QUESTION =================
            Text(
              question['question'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ================= OPTIONS =================
            ...['A', 'B', 'C', 'D'].map((key) {
              String optionText = question['options'][key];

              bool isSelected = selectedOptionKey == key;

              bool isCorrect =
                  optionText.toString().toLowerCase().trim() ==
                  question['answer'].toString().toLowerCase().trim();

              Color bgColor = Colors.white10;

              if (answered) {
                if (isCorrect) {
                  bgColor = Colors.green;
                } else if (isSelected) {
                  bgColor = Colors.red;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    padding: const EdgeInsets.all(14),
                  ),

                  onPressed: () => selectAnswer(key),

                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$key. $optionText",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            // ================= NEXT / SUBMIT =================
            if (answered)
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),

                  onPressed: isLast ? submitQuiz : nextQuestion,

                  child: Text(
                    isLast ? "Submit Quiz" : "Next Question",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}