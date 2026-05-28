import 'package:flutter/material.dart';
// import 'widgets/custom_drawer.dart';

class Quizzes extends StatefulWidget {
  const Quizzes({super.key});

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          "Manage Quizzes",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}