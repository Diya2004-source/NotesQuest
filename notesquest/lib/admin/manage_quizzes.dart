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

  List<TextEditingController> questionControllers = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // DEFAULT 15 QUESTIONS
    for (int i = 0; i < 15; i++) {
      questionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    courseController.dispose();
    topicController.dispose();

    for (var controller in questionControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // ================= INPUT STYLE =================
  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    );
  }

  // ================= ADD QUIZ =================
  Future<void> addQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      List<String> questions = [];

      for (var controller in questionControllers) {
        questions.add(controller.text.trim());
      }

      await FirebaseFirestore.instance.collection('quizzes').add({
        "category": courseController.text.trim(),
        "topic": topicController.text.trim(),
        "questions": questions,
        "createdBy": "Admin",
        "createdAt": FieldValue.serverTimestamp(),
      });

      // CLEAR
      courseController.clear();
      topicController.clear();

      for (var controller in questionControllers) {
        controller.clear();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Quiz Added Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
  }

  // ================= DELETE QUIZ =================
  Future<void> deleteQuiz(String id) async {
    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(id)
        .delete();
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
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const Text(
                      "Manage Quizzes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.quiz,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ================= FORM =================
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // COURSE
                    TextFormField(
                      controller: courseController,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          inputStyle("Course / Category", Icons.school),
                      validator: (value) =>
                          value!.isEmpty ? "Enter course" : null,
                    ),

                    const SizedBox(height: 15),

                    // TOPIC
                    TextFormField(
                      controller: topicController,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          inputStyle("Quiz Topic", Icons.topic),
                      validator: (value) =>
                          value!.isEmpty ? "Enter topic" : null,
                    ),

                    const SizedBox(height: 20),

                    // ================= QUESTIONS =================
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add 15 Questions",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Column(
                      children: List.generate(
                        questionControllers.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TextFormField(
                              controller: questionControllers[index],
                              style:
                                  const TextStyle(color: Colors.white),
                              maxLines: 2,
                              decoration: inputStyle(
                                "Question ${index + 1}",
                                Icons.help_outline,
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "Enter question"
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : addQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Add Quiz",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // ================= QUIZ LIST =================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "All Quizzes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('quizzes')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Something went wrong",
                      style: TextStyle(color: Colors.white),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Text(
                      "No quizzes added yet",
                      style: TextStyle(color: Colors.white70),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data =
                          docs[index].data() as Map<String, dynamic>;

                      final questions =
                          List<String>.from(data['questions'] ?? []);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    data['topic'] ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),

                                IconButton(
                                  onPressed: () =>
                                      deleteQuiz(docs[index].id),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "Course: ${data['category'] ?? ""}",
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 15),

                            const Text(
                              "Questions:",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Column(
                              children: List.generate(
                                questions.length,
                                (qIndex) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      bottom: 8,
                                    ),
                                    child: Align(
                                      alignment:
                                          Alignment.centerLeft,
                                      child: Text(
                                        "${qIndex + 1}. ${questions[qIndex]}",
                                        style: const TextStyle(
                                          color:
                                              Colors.white70,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
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