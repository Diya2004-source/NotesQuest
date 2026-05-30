import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import '../../services/quiz_service.dart';

import '../../widgets/quiz_card.dart';
import '../../widgets/loading_widget.dart';

import 'quiz_page.dart';

class QuizListPage extends StatefulWidget {
  const QuizListPage({super.key});

  @override
  State<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  final QuizService quizService = QuizService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text("Quizzes", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: FutureBuilder<List<QuizModel>>(
          future: quizService.fetchQuizzes(),

          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 5,
                itemBuilder: (_, __) => const QuizLoadingCard(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No quizzes found",
                    style: TextStyle(color: Colors.white)),
              );
            }

            final quizzes = snapshot.data!;

            // GROUP BY TOPIC
            final Map<String, List<QuizModel>> grouped = {};

            for (var q in quizzes) {
              grouped.putIfAbsent(q.topic, () => []);
              grouped[q.topic]!.add(q);
            }

            final topics = grouped.keys.toList();

            return ListView.builder(
              itemCount: topics.length,

              itemBuilder: (context, index) {
                String topic = topics[index];
                List<QuizModel> topicQuizzes = grouped[topic]!;

                return QuizCard(
                  title: topic,
                  category: topicQuizzes.first.category,
                  totalQuestions: topicQuizzes.length,

                  onTap: () {
                    List<Map<String, dynamic>> questions =
                        topicQuizzes.map((q) {
                      return {
                        "question": q.question,
                        "options": q.options,
                        "answer": q.answer,
                      };
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizPage(
                          questions: questions,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}