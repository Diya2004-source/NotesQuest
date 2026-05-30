import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void navigate(BuildContext context, String route) {
    Navigator.pop(context); 

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, route);
    });
  }

  Widget drawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    Color iconColor = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      hoverColor: Colors.white10,
      onTap: () => navigate(context, route),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: Column(
        children: [
          // HEADER 
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/EditProfile');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  "Quest User Panel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Learn • Practice • Grow",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // MENU 
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                drawerItem(
                  context: context,
                  icon: Icons.home,
                  title: "Home",
                  route: '/HomePage',
                ),

                drawerItem(
                  context: context,
                  icon: Icons.quiz,
                  title: "Quizzes",
                  route: '/QuizListPage',
                ),

                drawerItem(
                  context: context,
                  icon: Icons.note_alt,
                  title: "Notes",
                  route: '/NotesPage',
                ),

                drawerItem(
                  context: context,
                  icon: Icons.person,
                  title: "Edit Profile",
                  route: '/EditProfile',
                ),

                const Divider(
                  color: Colors.white24,
                  thickness: 1,
                  indent: 15,
                  endIndent: 15,
                ),

                drawerItem(
                  context: context,
                  icon: Icons.logout,
                  title: "Logout",
                  route: '/login',
                  iconColor: Colors.redAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}