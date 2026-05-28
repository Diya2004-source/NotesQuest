import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../admin/widgets/custom_drawer.dart';
import '../admin/widgets/custom_bottom_navbar.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final discountController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  // ---------------- ADD OFFER ----------------
  Future<void> addOffer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('offers').add({
        "title": titleController.text.trim(),
        "discount": int.tryParse(discountController.text.trim()) ?? 0,
        "description": descriptionController.text.trim(),
        "isActive": true,
        "createdAt": FieldValue.serverTimestamp(),
      });

      titleController.clear();
      discountController.clear();
      descriptionController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Offer Added Successfully"),
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

  // ---------------- DELETE OFFER ----------------
  Future<void> deleteOffer(String id) async {
    await FirebaseFirestore.instance.collection('offers').doc(id).delete();
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
    discountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      drawer: const CustomDrawer(),
      bottomNavigationBar: const CustomBottomNavbar(),

      appBar: AppBar(
        title: const Text("Manage Offers"),
        backgroundColor: const Color(0xFF0F172A),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // ---------------- FORM ----------------
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    TextFormField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputStyle("Offer Title", Icons.local_offer),
                      validator: (v) =>
                          v!.isEmpty ? "Enter title" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputStyle("Discount %", Icons.percent),
                      validator: (v) =>
                          v!.isEmpty ? "Enter discount" : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: descriptionController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputStyle("Description", Icons.description),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : addOffer,
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
                            : const Text("Add Offer"),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "All Offers",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ---------------- LIST ----------------
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('offers')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Offers Found",
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
                          child: ListTile(
                            leading: const Icon(
                              Icons.local_offer,
                              color: Colors.white,
                            ),
                            title: Text(
                              data['title'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "${data['discount']}% OFF\n${data['description']}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () => deleteOffer(data.id),
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