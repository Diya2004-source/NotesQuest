import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: Column(
        children: [
          //HEADER
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
                colors: [Color.fromARGB(255, 116, 14, 176), Color(0xFF7C3AED)],
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context); // CLOSE DRAWER
                      },

                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    // EDIT PROFILE BUTTON
                    InkWell(
                      onTap: () {
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

                // HEADING
                const Text(
                  "Admin Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Manage your Quest platform",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // ---------------- MENU ITEMS ----------------
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                drawerItem(
                  context: context,
                  icon: Icons.people_alt_outlined,
                  title: "Manage Users",
                  route: '/ManageUsers',
                ),

                drawerItem(
                  context: context,
                  icon: Icons.workspace_premium_outlined,
                  title: "Subscription Plans",
                  route: '/SubscriptionPlans',
                ),

                drawerItem(
                  context: context,
                  icon: Icons.bar_chart_outlined,
                  title: "Reports",
                  route: '/Reports',
                ),

                drawerItem(
                  context: context,
                  icon: Icons.local_offer_outlined,
                  title: "Offers",
                  route: '/Offers',
                ),

                drawerItem(
                  context: context,
                  icon: Icons.quiz_outlined,
                  title: "Quizzes",
                  route: '/Quizzes',
                ),

                const Divider(
                  color: Colors.white24,
                  thickness: 1,
                  indent: 15,
                  endIndent: 15,
                ),

                // LOGOUT
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
