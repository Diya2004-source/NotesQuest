import 'package:flutter/material.dart';
// import 'widgets/custom_drawer.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          "Reports",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}