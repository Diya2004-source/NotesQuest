import 'package:flutter/material.dart';

// import 'screens/quiz/quiz_list_page.dart';
// import 'screens/notes/notes_dashboard.dart';
// import 'screens/profile/profile_page.dart';

import './widgets/custom_header.dart';
import './widgets/custom_footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  // final List<Widget> pages = const [
  //   QuizListPage(),
  //   NotesPage(),
  //   ProfilePage(),
  // ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void toggleDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.closeDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0F172A),

      // ================= HEADER =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),

        //  MENU TOGGLE BUTTON
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: toggleDrawer,
        ),

        title: const Text(
          "User Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),

      // ================= DRAWER =================
      drawer: const CustomDrawer(),

      // ================= BODY =================
      //  body: pages[currentIndex]
      //  Placeholder for now
      body:Column(
        children: [
          Text('I am user dashboard'),
        ],
      ),

      // ================= FOOTER =================
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}