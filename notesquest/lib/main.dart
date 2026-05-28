import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'splash_screen.dart';

// ADMIN PAGES
import 'admin/admin_dashboard.dart';
import 'admin/manage_users.dart';
import 'admin/manage_quizzes.dart';
import 'admin/manage_offers.dart';
import 'admin/manage_subscription.dart';
import 'admin/reports_page.dart';
import 'admin/edit_profile.dart';

// LOGIN PAGE
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Quest());
}

class Quest extends StatelessWidget {
  const Quest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ---------------- THEME ----------------
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF7C4DFF),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
        ),

        useMaterial3: true,
      ),

      // ---------------- HOME ----------------
      home: const SplashScreen(),

      // ---------------- ROUTES ----------------
      routes: {

        '/AdminDashboard': (context) =>
            const AdminDashboard(),

        '/ManageUsers': (context) =>
            const ManageUsers(),

        '/SubscriptionPlans': (context) =>
            const SubscriptionPlans(),

        '/Reports': (context) =>
            const Reports(),

        '/Offers': (context) =>
            const Offers(),

        '/Quizzes': (context) =>
            const Quizzes(),

        '/EditProfile': (context) =>
            const EditProfilePage(),

        '/login': (context) =>
            const login(),
      },
    );
  }
}