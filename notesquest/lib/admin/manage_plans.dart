import 'package:flutter/material.dart';
// import 'widgets/custom_drawer.dart';

class SubscriptionPlans extends StatefulWidget {
  const SubscriptionPlans({super.key});

  @override
  State<SubscriptionPlans> createState() => _SubscriptionPlansState();
}

class _SubscriptionPlansState extends State<SubscriptionPlans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          "Manage Subscription Plans",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}