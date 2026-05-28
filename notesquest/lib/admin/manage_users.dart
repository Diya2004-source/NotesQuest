import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/custom_drawer.dart';
import 'widgets/custom_bottom_navbar.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      drawer: const CustomDrawer(),

      bottomNavigationBar: const CustomBottomNavbar(),

      body: SafeArea(
        child: Padding(
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

                    // MENU BUTTON
                    InkWell(
                      onTap: () {

                        if (Scaffold.of(context).isDrawerOpen) {
                          Navigator.pop(context);
                        } else {
                          Scaffold.of(context).openDrawer();
                        }
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

                    // TITLE
                    const Text(
                      "User's Details",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // USER ICON
                    Container(
                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),

                      child: const Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ---------------- SEARCH BOX ----------------
              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),

                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase();
                  });
                },

                decoration: InputDecoration(
                  hintText: "Search user...",
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),

                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white70,
                  ),

                  filled: true,
                  fillColor: Colors.white10,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ---------------- USERS LIST ----------------
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),

                  builder: (context, snapshot) {

                    // LOADING
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // NO USERS
                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {

                      return const Center(
                        child: Text(
                          "No Users Found",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    // ALL USERS
                    final users = snapshot.data!.docs;

                    // SEARCH FILTER
                    final filteredUsers = users.where((doc) {

                      final data =
                          doc.data() as Map<String, dynamic>;

                      final name =
                          (data['name'] ?? "")
                              .toString()
                              .toLowerCase();

                      final email =
                          (data['email'] ?? "")
                              .toString()
                              .toLowerCase();

                      return name.contains(searchText) ||
                          email.contains(searchText);

                    }).toList();

                    // NO SEARCH RESULTS
                    if (filteredUsers.isEmpty) {

                      return const Center(
                        child: Text(
                          "No Matching Users",

                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(

                      itemCount: filteredUsers.length,

                      itemBuilder: (context, index) {

                        final data =
                            filteredUsers[index].data()
                                as Map<String, dynamic>;

                        // SAFE DATA
                        final name =
                            data['name'] ?? "No Name";

                        final email =
                            data['email'] ?? "No Email";

                        final phone =
                            data['phone'] ?? "No Phone";

                        final course =
                            data['course'] ?? "No Course";

                        final semester =
                            data['semester'] ?? "";

                        final city =
                            data['city'] ?? "No City";

                        final isPremium =
                            data['isPremium'] ?? false;

                        final paymentStatus =
                            data['paymentStatus'] ??
                                "unpaid";

                        return Container(

                          margin: const EdgeInsets.only(
                            bottom: 16,
                          ),

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),

                            borderRadius:
                                BorderRadius.circular(20),

                            border: Border.all(
                              color: Colors.white10,
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              // ---------------- TOP ROW ----------------
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,

                                children: [

                                  Expanded(
                                    child: Text(
                                      name,

                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),

                                    decoration: BoxDecoration(

                                      color: isPremium
                                          ? Colors.green
                                          : Colors.red,

                                      borderRadius:
                                          BorderRadius.circular(
                                              20),
                                    ),

                                    child: Text(

                                      isPremium
                                          ? "PREMIUM"
                                          : "FREE",

                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // EMAIL
                              Row(
                                children: [

                                  const Icon(
                                    Icons.email_outlined,
                                    color: Colors.white70,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Text(
                                      email,

                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // PHONE
                              Row(
                                children: [

                                  const Icon(
                                    Icons.phone_outlined,
                                    color: Colors.white70,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    phone.toString(),

                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // COURSE
                              Row(
                                children: [

                                  const Icon(
                                    Icons.school_outlined,
                                    color: Colors.white70,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    "$course | Sem $semester",

                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // CITY
                              Row(
                                children: [

                                  const Icon(
                                    Icons.location_city_outlined,
                                    color: Colors.white70,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    city,

                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // PAYMENT STATUS
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.end,

                                children: [

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
                                    ),

                                    decoration: BoxDecoration(

                                      color:
                                          paymentStatus ==
                                                  "paid"
                                              ? Colors.green
                                              : Colors.orange,

                                      borderRadius:
                                          BorderRadius.circular(
                                              20),
                                    ),

                                    child: Text(

                                      paymentStatus
                                                  .toString()
                                                  .toLowerCase() ==
                                              "paid"
                                          ? "PAID"
                                          : "UNPAID",

                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}