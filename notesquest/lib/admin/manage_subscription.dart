import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../admin/widgets/custom_drawer.dart';
import '../admin/widgets/custom_bottom_navbar.dart';

class SubscriptionPlans extends StatefulWidget {
  const SubscriptionPlans({super.key});

  @override
  State<SubscriptionPlans> createState() => _SubscriptionPlansState();
}

class _SubscriptionPlansState extends State<SubscriptionPlans> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  // ---------------- ADD PLAN ----------------
  Future<void> addPlan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('subscription_plans')
          .add({
        "title": titleController.text.trim(),
        "price": int.tryParse(priceController.text.trim()) ?? 0,
        "duration": durationController.text.trim(),
        "description": descriptionController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      titleController.clear();
      priceController.clear();
      durationController.clear();
      descriptionController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Plan created successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // ---------------- DELETE PLAN ----------------
  Future<void> deletePlan(String id) async {
    await FirebaseFirestore.instance
        .collection('subscription_plans')
        .doc(id)
        .delete();
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      drawer: const CustomDrawer(),
      bottomNavigationBar: const CustomBottomNavbar(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // ================= FORM =================
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    TextFormField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputStyle("Plan Title", Icons.title),
                      validator: (v) =>
                          v!.isEmpty ? "Enter title" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          inputStyle("Price (₹)", Icons.currency_rupee),
                      validator: (v) =>
                          v!.isEmpty ? "Enter price" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: durationController,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          inputStyle("Duration", Icons.timer),
                      validator: (v) =>
                          v!.isEmpty ? "Enter duration" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: descriptionController,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          inputStyle("Description", Icons.description),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : addPlan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Create Plan"),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "All Plans",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ================= LIST =================
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('subscription_plans')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Plans Available",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index];

                        return Card(
                          color: Colors.white10,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8),
                          child: ListTile(
                            title: Text(
                              data['title'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              "₹${data['price']} • ${data['duration']}",
                              style: const TextStyle(
                                  color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () =>
                                  deletePlan(data.id),
                            ),
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