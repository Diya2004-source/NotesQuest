import 'package:flutter/material.dart';
// import 'widgets/custom_drawer.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          "Manage Offers",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}