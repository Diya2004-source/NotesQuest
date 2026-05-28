import 'package:flutter/material.dart';
// import 'widgets/custom_drawer.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          "Manage Users",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}