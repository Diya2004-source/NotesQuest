// lib/users/services/quiz_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/quiz_model.dart';

class QuizService {

  // ================= FIRESTORE INSTANCE =================

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  // ======================================================
  // GET QUIZZES API
  // FETCH DATA FROM FIREBASE
  // ======================================================

  Future<List<QuizModel>> fetchQuizzes() async {

    try {

      // ================= FETCH DATA =================

      QuerySnapshot snapshot = await firestore
          .collection('quizzes')
          .orderBy('createdAt', descending: true)
          .get();

      // ================= CONVERT TO MODEL =================

      List<QuizModel> quizzes = snapshot.docs.map((doc) {

        return QuizModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );

      }).toList();

      // ================= RETURN DATA =================

      return quizzes;

    } catch (e) {

      // ================= ERROR =================

      throw Exception("Failed to fetch quizzes: $e");
    }
  }

  // ======================================================
  // POST API
  // SAVE QUIZ RESULT
  // ======================================================

  Future<void> submitQuizResult({

    required String userId,
    required String quizId,
    required int score,
    required int totalQuestions,

  }) async {

    try {

      await firestore.collection('quiz_results').add({

        "userId": userId,

        "quizId": quizId,

        "score": score,

        "totalQuestions": totalQuestions,

        "createdAt": FieldValue.serverTimestamp(),
      });

    } catch (e) {

      throw Exception("Failed to submit result: $e");
    }
  }
}