import 'package:flutter/material.dart';

class ResultQuizPage extends StatelessWidget {
  final int score;
  final int total;

  const ResultQuizPage({
    super.key,
    required this.score,
    required this.total,
  });

  double get percentage {
    if (total == 0) return 0;
    return (score / total) * 100;
  }

  String get feedback {
    final percent = percentage;

    if (percent >= 80) {
      return "Excellent Performance 🚀";
    } else if (percent >= 50) {
      return "Good Work 👍 but you can improve more";
    } else {
      return "Needs Practice 📚 Keep Learning";
    }
  }

  Color get resultColor {
    final percent = percentage;

    if (percent >= 80) return Colors.green;
    if (percent >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                // ================= TITLE =================
                const Text(
                  "Quiz Result",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // ================= SCORE BOX =================
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "$score / $total",
                        style: TextStyle(
                          color: resultColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${percentage.toStringAsFixed(1)}%",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================= FEEDBACK =================
                Text(
                  feedback,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 40),

                // ================= BUTTON =================
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),

                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  },

                  child: const Text(
                    "Back to Dashboard",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}