import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../admin/widgets/custom_drawer.dart';
import '../admin/widgets/custom_bottom_navbar.dart';

class Quizzes extends StatefulWidget {
  const Quizzes({super.key});

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  final _formKey = GlobalKey<FormState>();

  final courseController = TextEditingController();
  final topicController = TextEditingController();

  final questionController = TextEditingController();
  final optionAController = TextEditingController();
  final optionBController = TextEditingController();
  final optionCController = TextEditingController();
  final optionDController = TextEditingController();
  final answerController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    courseController.dispose();
    topicController.dispose();
    questionController.dispose();
    optionAController.dispose();
    optionBController.dispose();
    optionCController.dispose();
    optionDController.dispose();
    answerController.dispose();
    super.dispose();
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: const TextStyle(color: Colors.white70),
    );
  }

  // ================= ADD QUIZ =================
  Future<void> addQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('quizzes').add({
        "category": courseController.text.trim(),
        "topic": topicController.text.trim(),
        "question": questionController.text.trim(),
        "options": {
          "A": optionAController.text.trim(),
          "B": optionBController.text.trim(),
          "C": optionCController.text.trim(),
          "D": optionDController.text.trim(),
        },
        "answer": answerController.text.trim().toUpperCase(),
        "createdBy": "Admin",
        "createdAt": FieldValue.serverTimestamp(),
      });

      // CLEAR
      courseController.clear();
      topicController.clear();
      questionController.clear();
      optionAController.clear();
      optionBController.clear();
      optionCController.clear();
      optionDController.clear();
      answerController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Quiz Added Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }

    setState(() => isLoading = false);
  }

  // ================= DELETE =================
  Future<void> deleteQuiz(String id) async {
    await FirebaseFirestore.instance.collection('quizzes').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const CustomBottomNavbar(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ================= TOP BAR =================
              Builder(
                builder: (context) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (Scaffold.of(context).isDrawerOpen) {
                          Navigator.pop(context);
                        } else {
                          Scaffold.of(context).openDrawer();
                        }
                      },
                      child: const Icon(Icons.menu, color: Colors.white),
                    ),
                    const Text(
                      "MCQ Quiz Manager",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.quiz, color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ================= FORM =================
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: courseController,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          inputStyle("Course / Category", Icons.school),
                      validator: (v) =>
                          v!.isEmpty ? "Enter category" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: topicController,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          inputStyle("Quiz Topic", Icons.topic),
                      validator: (v) =>
                          v!.isEmpty ? "Enter topic" : null,
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: questionController,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          inputStyle("Question", Icons.help),
                      validator: (v) =>
                          v!.isEmpty ? "Enter question" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: optionAController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputStyle("Option A", Icons.looks_one),
                      validator: (v) =>
                          v!.isEmpty ? "Enter option A" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: optionBController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputStyle("Option B", Icons.looks_two),
                      validator: (v) =>
                          v!.isEmpty ? "Enter option B" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: optionCController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputStyle("Option C", Icons.looks_3),
                      validator: (v) =>
                          v!.isEmpty ? "Enter option C" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: optionDController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputStyle("Option D", Icons.looks_4),
                      validator: (v) =>
                          v!.isEmpty ? "Enter option D" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: answerController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputStyle(
                          "Correct Answer (A/B/C/D)", Icons.check),
                      validator: (v) =>
                          v!.isEmpty ? "Enter correct answer" : null,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : addQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Submit Quiz",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ================= LIST =================
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('quizzes')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data =
                          docs[index].data() as Map<String, dynamic>;

                      final options =
                          data['options'] as Map<String, dynamic>? ?? {};

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data['topic']}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Q: ${data['question']}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 5),

                            Text("A: ${options['A'] ?? ''}",
                                style: const TextStyle(color: Colors.white70)),
                            Text("B: ${options['B'] ?? ''}",
                                style: const TextStyle(color: Colors.white70)),
                            Text("C: ${options['C'] ?? ''}",
                                style: const TextStyle(color: Colors.white70)),
                            Text("D: ${options['D'] ?? ''}",
                                style: const TextStyle(color: Colors.white70)),

                            const SizedBox(height: 5),

                            Text(
                              "Answer: ${data['answer']}",
                              style: const TextStyle(
                                  color: Colors.greenAccent),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () =>
                                    deleteQuiz(docs[index].id),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}