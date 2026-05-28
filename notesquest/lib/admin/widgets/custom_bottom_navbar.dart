import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1E293B),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, "/AdminDashboard");
            break;
          case 1:
            Navigator.pushReplacementNamed(context, "/ManageUsers");
            break;
          case 2:
            Navigator.pushReplacementNamed(context, "/Quizzes");
            break;
          case 3:
            Navigator.pushReplacementNamed(context, "/Reports");
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: "Users",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: "Quizzes",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "Reports",
        ),
      ],
    );
  }
}