import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/custom_drawer.dart';
import 'widgets/custom_bottom_navbar.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/chart_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  int totalUsers = 0;
  int premiumUsers = 0;
  int totalQuizzes = 0;

  double totalRevenue = 0;

  bool isLoading = true;

  // CHART DATA
  List<double> revenueData = [2, 4, 3, 7, 6, 10];

  @override
  void initState() {
    super.initState();

    fetchDashboardData();
  }

  // ---------------- FETCH DATA ----------------
  Future<void> fetchDashboardData() async {

    try {

      // USERS
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      totalUsers = userSnapshot.docs.length;

      // PREMIUM USERS
      final premiumSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('isPremium', isEqualTo: true)
          .get();

      premiumUsers = premiumSnapshot.docs.length;

      // QUIZZES
      final quizSnapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .get();

      totalQuizzes = quizSnapshot.docs.length;

      // PAYMENTS
      final paymentSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .get();

      double revenue = 0;

      for (var doc in paymentSnapshot.docs) {

        revenue += double.parse(
          doc['amount'].toString(),
        );
      }

      totalRevenue = revenue;

      setState(() {
        isLoading = false;
      });

    } catch (e) {

      print("Dashboard Error: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF0F172A),

      drawer: const CustomDrawer(),

      bottomNavigationBar: const CustomBottomNavbar(),

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : SafeArea(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    // ---------------- TOP BAR ----------------
                    Builder(
                      builder: (context) => Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [

                          InkWell(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },

                            child: Container(
                              padding: const EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),

                              child: const Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const Text(
                            "Admin Dashboard",

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
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),

                            child: const Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ---------------- DASHBOARD CARDS ----------------
                    GridView.count(

                      physics:
                          const NeverScrollableScrollPhysics(),

                      shrinkWrap: true,

                      crossAxisCount: 2,

                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,

                      childAspectRatio: 1.15,

                      children: [

                        DashboardCard(
                          title: "Total Users",
                          value: totalUsers.toString(),
                          icon: Icons.people,
                          color: Colors.blue,
                        ),

                        DashboardCard(
                          title: "Revenue",
                          value: "₹${totalRevenue.toInt()}",
                          icon: Icons.currency_rupee,
                          color: Colors.green,
                        ),

                        DashboardCard(
                          title: "Quiz Topics",
                          value: totalQuizzes.toString(),
                          icon: Icons.quiz,
                          color: Colors.orange,
                        ),

                        DashboardCard(
                          title: "Premium Users",
                          value: premiumUsers.toString(),
                          icon: Icons.workspace_premium,
                          color: Colors.purple,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ---------------- CHART ----------------
                    ChartWidget(
                      revenueData: revenueData,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}