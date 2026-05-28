import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../admin/widgets/custom_drawer.dart';
import '../admin/widgets/custom_bottom_navbar.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {

  Stream<int> getUsersCount() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((s) => s.docs.length);
  }

  Stream<int> getPlansCount() {
    return FirebaseFirestore.instance
        .collection('subscription_plans')
        .snapshots()
        .map((s) => s.docs.length);
  }

  Stream<int> getRevenue() {
    return FirebaseFirestore.instance
        .collection('payments')
        .snapshots()
        .map((snapshot) {
      int total = 0;
      for (var doc in snapshot.docs) {
        total += (doc['amount'] ?? 0) as int;
      }
      return total;
    });
  }

  Widget reportCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 5),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      // ✅ DRAWER
      drawer: const CustomDrawer(),

      // ✅ BOTTOM NAVBAR
      bottomNavigationBar: const CustomBottomNavbar(),

      // ✅ APP BAR FIX (IMPORTANT)
      appBar: AppBar(
        title: const Text("Reports"),
        backgroundColor: const Color(0xFF0F172A),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              StreamBuilder<int>(
                stream: getUsersCount(),
                builder: (context, snapshot) {
                  return reportCard(
                    "Total Users",
                    "${snapshot.data ?? 0}",
                    Icons.people,
                  );
                },
              ),

              const SizedBox(height: 15),

              StreamBuilder<int>(
                stream: getPlansCount(),
                builder: (context, snapshot) {
                  return reportCard(
                    "Subscription Plans",
                    "${snapshot.data ?? 0}",
                    Icons.workspace_premium,
                  );
                },
              ),

              const SizedBox(height: 15),

              StreamBuilder<int>(
                stream: getRevenue(),
                builder: (context, snapshot) {
                  return reportCard(
                    "Total Revenue",
                    "₹${snapshot.data ?? 0}",
                    Icons.currency_rupee,
                  );
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text("Download Report (PDF)"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}