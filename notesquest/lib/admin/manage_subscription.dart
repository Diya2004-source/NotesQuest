import 'package:flutter/material.dart';
// import 'widgets/custom_drawer.dart';

class ManageSubscription extends StatefulWidget {
  const ManageSubscription({super.key});

  @override
  State<ManageSubscription> createState() => _ManageSubscriptionState();
}

class _ManageSubscriptionState extends State<ManageSubscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          "Manage Subscription",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}